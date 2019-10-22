//
//  main.swift
//  HistoryDataDump
//
//  Created by Harry Li on 10/01/2015.
//  Copyright (c) 2014-2019 Hanfei Li. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
// of the Software, and to permit persons to whom the Software is furnished to
// do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation
import SwiftIB

// constants
let EXT = "history_raw"
let HEADER_LEN = 19

var conf = HDDConfig(arg_array: CommandLine.arguments)
var tickers = conf.tickers
var fman = FileManager.default
var wrapper = HistoryDataWrapper()
var client = EClientSocket(p_eWrapper: wrapper, p_anyWrapper: wrapper)

func getLastestDate(filename: String) -> Int64 {
    let fcontent = try! NSString(contentsOfFile: filename, encoding: String.Encoding.utf8.rawValue)
    var count = 0
    fcontent.enumerateLines({ (line: String!, p: UnsafeMutablePointer<ObjCBool>) -> Void in
        count += 1
    })
    var ret: Int64 = -1
    fcontent.enumerateLines({ (line: String!, p: UnsafeMutablePointer<ObjCBool>) -> Void in
        count -= 1
        if count == 0 {
            
            let datestr = (line as NSString).substring(with: NSRange(location: 0, length: HEADER_LEN))
            ret = HDDUtil.fastStrToTS(timestamp: datestr, tz_name: wrapper.timezone)
        }
    })
    return ret
}

func downloadHistoryData(filename: String, ticker: String, requestId: Int, append: Bool = false, secType: String = "STK", currency: String = "USD", multiplier: String = "", expire: String = "", exchange: String = "SMART", pexchange: String = "ISLAND") {
    var loc = ticker
    var wts = "TRADES"
    if exchange == "IDEALPRO" {
        loc = "\(ticker).\(currency)"
        wts = "BID_ASK"
    }
    if (conf.sleepInterval < 20.0) && (wts == "BID_ASK") {
        conf.sleepInterval = 20.0
    }
    let con = Contract(p_conId: 0, p_symbol: ticker, p_secType: secType, p_expiry: expire, p_strike: 0.0, p_right: "", p_multiplier: multiplier,
        p_exchange: exchange, p_currency: currency, p_localSymbol: loc, p_tradingClass: "", p_comboLegs: nil, p_primaryExch: pexchange,
        p_includeExpired: false, p_secIdType: "", p_secId: "")
    var lf: FileHandle?
    if append {
        let next = getLastestDate(filename: filename)
        if next != -1 {
            wrapper.currentStart = next
        }
        if wrapper.currentStart <= wrapper.sinceTS {
            print("\t[\(ticker)] fully downloaded. Skip.")
            return
        }
        print("\tAppending \(filename), starting date [\(HDDUtil.tsToStr(timestamp: wrapper.currentStart, api: false, tz_name: wrapper.timezone))]")
        lf = FileHandle(forUpdatingAtPath: filename)
        if lf != nil {
            lf?.seekToEndOfFile()
        }
    } else {
        fman.createFile(atPath: filename, contents: nil, attributes: nil)
        lf = FileHandle(forWritingAtPath: filename)
    }
    wrapper.currentTicker = ticker
    while wrapper.currentStart > wrapper.sinceTS {
        let begin = NSDate().timeIntervalSinceReferenceDate
        let localStart = wrapper.currentStart
        wrapper.currentStart = -1
        wrapper.contents.removeAll(keepingCapacity: true)
        wrapper.reqComplete = false
        wrapper.broken = false
        let sdt = conf.sinceDatetime.components(separatedBy: " ")[0]
        if HDDUtil.equalsDaystart(timestamp: localStart, tz_name: wrapper.timezone, daystart: conf.dayStart, datestart: sdt) {
            print("(reaching day start \(conf.dayStart), continue next)")
            break
        }
        let ut = HDDUtil.tsToStr(timestamp: localStart, api: true, tz_name: wrapper.timezone)
        client.reqHistoricalData(requestId, contract: con, endDateTime: "\(ut) \(wrapper.timezone)", durationStr: conf.duration, barSizeSetting: conf.barsize, whatToShow: wts, useRTH: conf.rth, formatDate: 2, chartOptions: nil)
        print("request (\(conf.duration)) (\(conf.barsize)) bars, until \(ut) \(wrapper.timezone)")
        while (wrapper.reqComplete == false) && (wrapper.broken == false) && (wrapper.extraSleep <= 0.0)
        { Thread.sleep(forTimeInterval: TimeInterval(0.05)) }
        if wrapper.broken {
            Thread.sleep(forTimeInterval: TimeInterval(2.0))
            wrapper.currentStart = localStart
            client = EClientSocket(p_eWrapper: wrapper, p_anyWrapper: wrapper)
            client.eConnect(conf.host, p_port: conf.port)
            wrapper.closing = false
            continue
        }
        if let file = lf {
            for c in wrapper.contents {
                file.write(c.data(using: String.Encoding.utf8, allowLossyConversion: true)!)
            }
            file.synchronizeFile()
        }
        print("(sleep for \(conf.sleepInterval + wrapper.extraSleep) secs)...")
        Thread.sleep(until: NSDate(timeIntervalSinceReferenceDate: begin + conf.sleepInterval + wrapper.extraSleep) as Date)
        if wrapper.extraSleep > 0 {
            wrapper.currentStart = localStart
            wrapper.extraSleep = 0
        }
    }
    if lf != nil {
        lf?.closeFile()
    }
}

if conf.help {
    exit(EXIT_SUCCESS)
}

conf.printConf()
print("Connecting to IB API...")
client.eConnect(conf.host, port: Int(conf.port), clientId: conf.clientID)
wrapper.closing = false

for i in 0 ..< tickers.count {
    var ticker = tickers[i]
    var ex = conf.exchange
    var pex = conf.primaryEx
    let cmp = tickers[i].components(separatedBy: ",")
    var ins = "STK"
    var currency = "USD"
    var multiplier = ""
    var expire = ""
    if cmp.count >= 5 {
        ticker = cmp[0]
        currency = cmp[1]
        ins = cmp[2]
        ex = cmp[3]
        pex = cmp[4]
        if cmp.count >= 7 {
            multiplier = cmp[5]
            expire = cmp[6]
        }
    }
    
    wrapper.timezone = "America/New_York"
    wrapper.sinceTS = HDDUtil.strToTS(timestamp: conf.sinceDatetime, api: true, tz_name: wrapper.timezone)
    wrapper.currentStart = HDDUtil.strToTS(timestamp: conf.untilDatetime, api: true, tz_name: wrapper.timezone)
    var lticker = ticker
    if ins == "CASH" {
        lticker = "\(ticker).\(currency)"
    }
    let fn = conf.outputDir.appending("[\(lticker)][\(ex)-\(pex)][\(conf.sinceDatetime)]-[\(conf.untilDatetime)][\(conf.barsize)].\(EXT)")
    let fname = conf.normal_filename ? fn.replacingOccurrences(of: ":", with: "") : fn
    if fman.fileExists(atPath: fname) {
        if conf.append {
            downloadHistoryData(filename: fname, ticker: ticker, requestId: i, append: true, secType: ins, currency: currency, multiplier: multiplier, expire: expire, exchange: ex, pexchange: pex)
            continue
        } else {
            print("Skip \(ticker) : File exists")
            continue
        }
    } else {
        downloadHistoryData(filename: fname, ticker: ticker, requestId: i, secType: ins, currency: currency, multiplier: multiplier, expire: expire, exchange: ex, pexchange: pex)
    }
}

Thread.sleep(forTimeInterval: TimeInterval(3.0))
wrapper.closing = true
client.eDisconnect()
client.close()


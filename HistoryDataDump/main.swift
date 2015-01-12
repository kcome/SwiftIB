//
//  main.swift
//  HistoryDataDump
//
//  Created by Harry Li on 10/01/2015.
//  Copyright (c) 2014,2015 Hanfei Li. All rights reserved.
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

func tsToStr(timestamp: Int64, api: Bool) -> String {
    let time = NSDate(timeIntervalSince1970: Double(timestamp))
    let fmt = NSDateFormatter()
    fmt.timeZone = NSTimeZone(name: "US/Eastern")
    fmt.dateFormat = api ? "yyyyMMdd HH:mm:ss" : "yyyy-MM-dd\tHH:mm:ss"
    return fmt.stringFromDate(time)
}

func strToTS(timestamp: String) -> Int64 {
    let fmt = NSDateFormatter()
    fmt.timeZone = NSTimeZone(name: "US/Eastern")
    fmt.dateFormat = "yyyyMMdd HH:mm:ss"
    if let dt = fmt.dateFromString(timestamp) {
        return Int64(dt.timeIntervalSince1970)
    }
    return -1
}


// global variables between Main and HistoryDataWrapper
var closing = false
var reqComplete = false
var currentStart: Int64 = -1
var sinceTS: Int64 = 0
var broken = false

class HistoryDataWrapper: EWrapper {
    var contents: [String] = [String](count: 2000, repeatedValue: "")
    init() {
    }
    // currently unused callbacks
    func accountDownloadEnd(accountName: String){}
    func tickPrice(tickerId: Int, field: Int, price: Double, canAutoExecute: Int) {}
    func tickSize(tickerId: Int, field: Int, size: Int) {}
    func tickGeneric(tickerId: Int, tickType: Int, value: Double) {}
    func tickString(tickerId: Int, tickType: Int, value: String) {}
    func tickOptionComputation(tickerId: Int, field: Int, impliedVol: Double, delta: Double, optPrice: Double, pvDividend: Double, gamma: Double, vega: Double, theta: Double, undPrice: Double) {}
    func tickEFP(tickerId: Int, tickType: Int, basisPoints: Double,
        formattedBasisPoints: String, impliedFuture: Double, holdDays: Int,
        futureExpiry: String, dividendImpact: Double, dividendsToExpiry: Double){}
    func orderStatus(orderId: Int, status: String, filled: Int, remaining: Int,
        avgFillPrice: Double, permId: Int, parentId: Int, lastFillPrice: Double,
        clientId: Int, whyHeld: String){}
    func openOrder(orderId: Int, contract: Contract, order: Order, orderState: OrderState){}
    func openOrderEnd(){}
    func updateAccountValue(key: String, value: String, currency: String, accountName: String){}
    func updatePortfolio(contract: Contract, position: Int, marketPrice: Double, marketValue: Double,
        averageCost: Double, unrealizedPNL: Double, realizedPNL: Double, accountName: String){}
    func updateAccountTime(timeStamp: String){}
    func nextValidId(orderId: Int){}
    func contractDetails(reqId: Int, contractDetails: ContractDetails){}
    func bondContractDetails(reqId: Int, contractDetails: ContractDetails){}
    func contractDetailsEnd(reqId: Int){}
    func execDetails(reqId: Int, contract: Contract, execution: Execution){}
    func execDetailsEnd(reqId: Int){}
    func updateMktDepth(tickerId: Int, position: Int, operation: Int, side: Int, price: Double, size: Int){}
    func updateMktDepthL2(tickerId: Int, position: Int, marketMaker: String, operation: Int,
        side: Int, price: Double, size: Int){}
    func updateNewsBulletin(msgId: Int, msgType: Int, message: String, origExchange: String){}
    func managedAccounts(accountsList: String){}
    func receiveFA(faDataType: Int, xml: String){}
    func scannerParameters(xml: String){}
    func scannerData(reqId: Int, rank: Int, contractDetails: ContractDetails, distance: String,
        benchmark: String, projection: String, legsStr: String){}
    func scannerDataEnd(reqId: Int){}
    func realtimeBar(reqId: Int, time: Int64, open: Double, high: Double, low: Double, close: Double, volume: Int64, wap: Double, count: Int) {}
    func currentTime(time: Int64){}
    func fundamentalData(reqId: Int, data: String){}
    func deltaNeutralValidation(reqId: Int, underComp: UnderComp){}
    func tickSnapshotEnd(reqId: Int){}
    func marketDataType(reqId: Int, marketDataType: Int){}
    func commissionReport(commissionReport: CommissionReport){}
    func position(account: String, contract: Contract, pos: Int, avgCost: Double){}
    func positionEnd(){}
    func accountSummary(reqId: Int, account: String, tag: String, value: String, currency: String){}
    func accountSummaryEnd(reqId: Int){}
    func verifyMessageAPI(apiData: String){}
    func verifyCompleted(isSuccessful: Bool, errorText: String){}
    func displayGroupList(reqId: Int, groups: String){}
    func displayGroupUpdated(reqId: Int, contractInfo: String){}
    // end of unused functinos
    
    // error handling
    func error( e: NSException) {}
    func error( str: String) {
        println("error: \(str)")
    }
    func error( id: Int, errorCode: Int, errorMsg:String) {
        switch errorCode {
        case 2106:
            println("2106 [A historical data farm is connected]\n\tmsg:\(errorMsg)")
        default:
            println("error: id(\(id)) code(\(errorCode)) msg:\(errorMsg)")
        }
    }
    func connectionClosed() {
        if !closing {
            println ("!!CONNECTION CLOSE")
            broken = true
        }
    }

    func historicalData(reqId: Int, date: String, open: Double, high: Double, low: Double,
        close: Double, volume: Int, count: Int, WAP: Double, hasGaps: Bool) {
            var s = ""
            if date.hasPrefix("finished-") {
                println("\(date)")
                reqComplete = true
            } else {
                let ts : Int64 = (date as NSString).longLongValue
                if currentStart < 0 {
                    currentStart = ts
                }
                if ts < sinceTS {
                    return
                }
                let iHasGaps = hasGaps ? 1 : 0
                s = "\(tsToStr(ts, false))\t\(open)\t\(high)\t\(low)\t\(close)\t\(volume)\t\(count)\t\(WAP)\t\(iHasGaps)"
            }
            if !s.isEmpty {
                s = s + "\n"
                self.contents.insert(s, atIndex: 0)
            }
    }
}

var host = "127.0.0.1"
var port: UInt32 = 4001
var tickers = [String]()
var exchange = "SMART"
var primaryEx = "ISLAND"
var rth = 1
var sinceDatetime = "20150101 09:30:00"
var untilDatetime = "20150101 16:00:00"
var barsize = "5 mins"
var unixts = 1
var duration = "2000 S"
var outputDir: String = NSFileManager.defaultManager().currentDirectoryPath

var argValue:[Bool] = [Bool](count: Process.arguments.count, repeatedValue: false)
var index = 1
for arg in Process.arguments[1..<Process.arguments.count] {
    switch arg {
    case "--host":
        if index+1<Process.arguments.count {host = Process.arguments[index+1]}
        argValue[index+1] = true
    case "--port":
        if index+1<Process.arguments.count {
            if let p = Process.arguments[index+1].toInt() {
                port = UInt32(p)
            }
        }
        argValue[index+1] = true
    case "--rth":
        if index+1<Process.arguments.count {
            if let p = Process.arguments[index+1].toInt() {
                rth = p == 0 ? 0 : 1
            } else {
                rth = Process.arguments[index+1].lowercaseString == "true" ? 1 : 0
            }
        }
        argValue[index+1] = true
    case "--until":
        if index+1<Process.arguments.count {
            untilDatetime = Process.arguments[index+1]
        }
        argValue[index+1] = true
    case "--since":
        if index+1<Process.arguments.count {
            sinceDatetime = Process.arguments[index+1]
            sinceTS = strToTS(Process.arguments[index+1])
        }
        argValue[index+1] = true
    case "--barsize":
        if index+1<Process.arguments.count {
            barsize = Process.arguments[index+1]
        }
        argValue[index+1] = true
    case "--duration":
        if index+1<Process.arguments.count {
            duration = Process.arguments[index+1]
        }
        argValue[index+1] = true
    case "--exchange":
        if index+1<Process.arguments.count {
            let ex = Process.arguments[index+1]
            let exs = ex.componentsSeparatedByString(":")
            if exs.count >= 2 { primaryEx = exs[1] }
            if exs.count >= 1 { exchange = exs[0] }
        }
        argValue[index+1] = true
    case "--output":
        if index+1<Process.arguments.count {outputDir = Process.arguments[index+1]}
        argValue[index+1] = true
    default:
        if argValue[index] == false {
            tickers.append(arg)
        }
    }
    index += 1
}

var fman = NSFileManager.defaultManager()
var wrapper = HistoryDataWrapper()
var client = EClientSocket(p_eWrapper: wrapper, p_anyWrapper: wrapper)
client.eConnect(host, p_port: port)
closing = false
broken = false
println("Connecting to IB API...")
for i in 0 ..< tickers.count {
    sinceTS = strToTS(sinceDatetime)
    currentStart = strToTS(untilDatetime)
    var con = Contract(p_conId: 0, p_symbol: tickers[i], p_secType: "STK", p_expiry: "", p_strike: 0.0, p_right: "", p_multiplier: "",
        p_exchange: exchange, p_currency: "USD", p_localSymbol: "", p_tradingClass: "", p_comboLegs: nil, p_primaryExch: primaryEx,
        p_includeExpired: false, p_secIdType: "", p_secId: "")
    let fname = outputDir.stringByAppendingPathComponent("[\(tickers[i])][\(exchange)-\(primaryEx)][\(sinceDatetime)]-[\(untilDatetime)][\(barsize)].history_raw")
    fman.createFileAtPath(fname, contents: nil, attributes: nil)
    var lf = NSFileHandle(forWritingAtPath: fname)
    while currentStart > sinceTS {
        reqComplete = false
        let localStart = currentStart
        currentStart = -1
        wrapper.contents.removeAll(keepCapacity: true)
        client.reqHistoricalData(i, contract: con, endDateTime: "\(tsToStr(localStart, true)) EST", durationStr: duration, barSizeSetting: barsize, whatToShow: "TRADES", useRTH: rth, formatDate: 2, chartOptions: nil)
        while (reqComplete == false) && (broken == false)
            { NSThread.sleepForTimeInterval(NSTimeInterval(0.05)) }
        if broken {
            client.close()
            NSThread.sleepForTimeInterval(NSTimeInterval(2.0))
            currentStart = localStart
            client.eConnect(host, p_port: port)
            closing = false
            broken = false
            continue
        }
        if let file = lf {
            for c in wrapper.contents {
                file.writeData(c.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
            }
            file.synchronizeFile()
        }
        println("(sleep for 10 secs)...")
        NSThread.sleepForTimeInterval(NSTimeInterval(10.0))
    }
    if lf != nil {
        lf?.closeFile()
    }
}

NSThread.sleepForTimeInterval(NSTimeInterval(3.0))
closing = true
client.eDisconnect()
client.close()


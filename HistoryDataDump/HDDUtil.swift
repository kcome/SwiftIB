//
//  HDDUtil.swift
//  SwiftIB
//
//  Created by Harry Li on 15/01/2015.
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

struct HDDConfig {
    // default values
    var host = "127.0.0.1"
    var port: UInt32 = 4001
    var tickers = [String]()
    var exchange = "SMART"
    var primaryEx = "ISLAND"
    var rth = 1
    var barsize = "5 mins"
    var unixts = 1
    var duration = "10800 S" // 3 hours
    var sleepInterval = 10.0
    var outputDir: String = NSFileManager.defaultManager().currentDirectoryPath
    var append = false
    var sinceDatetime = ""
    var untilDatetime = ""
    var clientID = 1
    
    init(arg_array: [String]) {
        let now = NSDate(timeIntervalSinceNow: 0)
        sinceDatetime = HDDUtil.tsToStr( Int64(now.timeIntervalSince1970 - 24 * 3600), api: true)
        untilDatetime = HDDUtil.tsToStr( Int64(now.timeIntervalSince1970), api: true)

        var argValue:[Bool] = [Bool](count: arg_array.count, repeatedValue: false)
        var index = 1
        for arg in arg_array[1..<arg_array.count] {
            switch arg {
            case "--host":
                if index+1<arg_array.count {self.host = arg_array[index+1]}
                argValue[index+1] = true
            case "--port":
                if index+1<arg_array.count {
                    if let p = arg_array[index+1].toInt() {
                        self.port = UInt32(p)
                    }
                }
                argValue[index+1] = true
            case "--rth":
                if index+1<arg_array.count {
                    if let p = arg_array[index+1].toInt() {
                        self.rth = p == 0 ? 0 : 1
                    } else {
                        self.rth = arg_array[index+1].lowercaseString == "true" ? 1 : 0
                    }
                }
                argValue[index+1] = true
            case "--until":
                if index+1<arg_array.count {
                    self.untilDatetime = arg_array[index+1]
                }
                argValue[index+1] = true
            case "--since":
                if index+1<arg_array.count {
                    self.sinceDatetime = arg_array[index+1]
                }
                argValue[index+1] = true
            case "--barsize":
                if index+1<arg_array.count {
                    self.barsize = arg_array[index+1]
                }
                argValue[index+1] = true
            case "--duration":
                if index+1<arg_array.count {
                    self.duration = arg_array[index+1]
                }
                argValue[index+1] = true
            case "--exchange":
                if index+1<arg_array.count {
                    let ex = arg_array[index+1]
                    let exs = ex.componentsSeparatedByString(":")
                    if exs.count >= 2 { self.primaryEx = exs[1] }
                    if exs.count >= 1 { self.exchange = exs[0] }
                }
                argValue[index+1] = true
            case "--output":
                if index+1<arg_array.count { self.outputDir = arg_array[index+1] }
                argValue[index+1] = true
            case "--symbols":
                if index+1<arg_array.count {
                    let fileCont = String(contentsOfFile:arg_array[index+1] , encoding: NSUTF8StringEncoding, error: nil)
                    if fileCont != nil {
                        let arr = fileCont?.componentsSeparatedByString("\n")
                        if arr != nil {
                            for sym in arr! { self.tickers.append(sym) }
                        }
                    }
                }
                argValue[index+1] = true
            case "--sleep":
                if index+1<arg_array.count {
                    let sd = NSString(string: arg_array[index+1]).doubleValue
                    if sd != 0 {
                        self.sleepInterval = sd
                    }
                }
                argValue[index+1] = true
            case "--append":
                self.append = true
            case "--clientID":
                if index+1<arg_array.count {
                    let iv = arg_array[index+1].toInt()
                    if iv != nil {
                        self.clientID = iv!
                    }
                }
                argValue[index+1] = true
            default:
                if argValue[index] == false {
                    self.tickers.append(arg)
                }
            }
            index += 1
        }
    }
    
    func printConf() {
        println("Fetching tickers: \(tickers)")
        println("Configuration:\nHost: \(host)")
        println("Port: \(port)")
        println("Start date (EST): \(sinceDatetime)")
        println("End date (EST): \(untilDatetime)")
        println("Output: \(outputDir)")
        println("Exchange: \(exchange) - \(primaryEx)")
        println("Barsize: \(barsize)")
        println("Duration: \(duration)")
        println("Append mode: \(append)")
        println("Client ID: \(clientID)")
    }
}

class HDDUtil {

    class func tsToStr(timestamp: Int64, api: Bool) -> String {
        let time = NSDate(timeIntervalSince1970: Double(timestamp))
        let fmt = NSDateFormatter()
        fmt.timeZone = NSTimeZone(name: "US/Eastern")
        fmt.dateFormat = api ? "yyyyMMdd HH:mm:ss" : "yyyy-MM-dd\tHH:mm:ss"
        return fmt.stringFromDate(time)
    }
    
    class func strToTS(timestamp: String, api: Bool) -> Int64 {
        let fmt = NSDateFormatter()
        fmt.timeZone = NSTimeZone(name: "US/Eastern")
        fmt.dateFormat = api ? "yyyyMMdd HH:mm:ss" : "yyyy-MM-dd\tHH:mm:ss"
        if let dt = fmt.dateFromString(timestamp) {
            return Int64(dt.timeIntervalSince1970)
        }
        return -1
    }
    
    class func parseBarsize(sbarsize: String) -> Int {
        let cmps = sbarsize.componentsSeparatedByString(" ")
        if cmps.count == 2 {
            var base = 1
            if cmps[1].hasPrefix("min") { base = 60 }
            else if cmps[1].hasPrefix("hour") { base = 60 * 60 }
            else if cmps[1].hasPrefix("day") { base = 60 * 60 * 24 }
            if let v = cmps[0].toInt() {
                return v * base
            }
        }
        return -1
    }
}

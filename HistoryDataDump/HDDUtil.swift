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

class HDDUtil {

    class func tsToStr(timestamp: Int64, api: Bool) -> String {
        let time = NSDate(timeIntervalSince1970: Double(timestamp))
        let fmt = NSDateFormatter()
        fmt.timeZone = NSTimeZone(name: "US/Eastern")
        fmt.dateFormat = api ? "yyyyMMdd HH:mm:ss" : "yyyy-MM-dd\tHH:mm:ss"
        return fmt.stringFromDate(time)
    }
    
    class func strToTS(timestamp: String) -> Int64 {
        let fmt = NSDateFormatter()
        fmt.timeZone = NSTimeZone(name: "US/Eastern")
        fmt.dateFormat = "yyyyMMdd HH:mm:ss"
        if let dt = fmt.dateFromString(timestamp) {
            return Int64(dt.timeIntervalSince1970)
        }
        return -1
    }
    
}

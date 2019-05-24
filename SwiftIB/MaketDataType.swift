//
//  MaketDataType.swift
//  SwiftIB
//
//  Created by Hanfei Li on 1/01/2015.
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

class MarketDataType {

    // constants - market data types
    enum MarketDataEnum: Int {
        case realtime = 1
        case frozen = 2
    }
    
    class func getField(_ marketDataType: Int) -> String {        
        if let marketData = MarketDataEnum(rawValue: marketDataType) {
            switch (marketData) {
            case .realtime:
                return "Real-Time"
            case .frozen:
                return "Frozen"
            }
        }
        return "Unknown"
    }
    
    class func getFields() -> [String] {
        // DOC: Original Java source is confusing, so hard code the totalFields here
        let totalFields = 2
        var fields = [String](repeating: "", count: totalFields)
        for i in 1...totalFields {
            fields[i] = MarketDataType.getField(i)
        }
        return fields
    }

}

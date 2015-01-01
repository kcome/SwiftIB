//
//  MaketDataType.swift
//  SwiftIB
//
//  Created by Hanfei Li on 1/01/2015.
//  Copyright (c) 2015 Hanfei Li. All rights reserved.
//

import Foundation

class MarketDataType {

    // constants - market data types
    enum MarketDataEnum: Int {
        case REALTIME = 1
        case FROZEN = 2
    }
    
    class func getField(marketDataType: Int) -> String {        
        if let marketData = MarketDataEnum(rawValue: marketDataType) {
            switch (marketData) {
            case .REALTIME:
                return "Real-Time"
            case .FROZEN:
                return "Frozen"
            default:
                return "Unknown"
            }
        }
        return "Unknown"
    }
    
    class func getFields() -> [String] {
        // DOC: Original Java source is confusing, so hard code the totalFields here
        var totalFields = 2
        var fields = [String](count: totalFields, repeatedValue: "")
        for i in 1...totalFields {
            fields[i] = MarketDataType.getField(i)
        }
        return fields
    }

}

//
//  TickType.swift
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

class TickType {
    
    // constants - tick types
    enum TickTypeEnum: Int {
        case bid_SIZE   = 0
        case bid        = 1
        case ask        = 2
        case ask_SIZE   = 3
        case last       = 4
        case last_SIZE  = 5
        case high       = 6
        case low        = 7
        case volume     = 8
        case close      = 9
        case bid_OPTION = 10
        case ask_OPTION = 11
        case last_OPTION = 12
        case model_OPTION = 13
        case open         = 14
        case low_13_WEEK  = 15
        case high_13_WEEK = 16
        case low_26_WEEK  = 17
        case high_26_WEEK = 18
        case low_52_WEEK  = 19
        case high_52_WEEK = 20
        case avg_VOLUME   = 21
        case open_INTEREST = 22
        case option_HISTORICAL_VOL = 23
        case option_IMPLIED_VOL = 24
        case option_BID_EXCH = 25
        case option_ASK_EXCH = 26
        case option_CALL_OPEN_INTEREST = 27
        case option_PUT_OPEN_INTEREST = 28
        case option_CALL_VOLUME = 29
        case option_PUT_VOLUME = 30
        case index_FUTURE_PREMIUM = 31
        case bid_EXCH = 32
        case ask_EXCH = 33
        case auction_VOLUME = 34
        case auction_PRICE = 35
        case auction_IMBALANCE = 36
        case mark_PRICE = 37
        case bid_EFP_COMPUTATION  = 38
        case ask_EFP_COMPUTATION  = 39
        case last_EFP_COMPUTATION = 40
        case open_EFP_COMPUTATION = 41
        case high_EFP_COMPUTATION = 42
        case low_EFP_COMPUTATION = 43
        case close_EFP_COMPUTATION = 44
        case last_TIMESTAMP = 45
        case shortable = 46
        case fundamental_RATIOS = 47
        case rt_VOLUME = 48
        case halted = 49
        case bid_YIELD = 50
        case ask_YIELD = 51
        case last_YIELD = 52
        case cust_OPTION_COMPUTATION = 53
        case trade_COUNT = 54
        case trade_RATE = 55
        case volume_RATE = 56
        case last_RTH_TRADE = 57
        case regulatory_IMBALANCE = 61
    }   

    class func getField(_ tickType: Int) -> String {
        
        if let eTickType = TickTypeEnum(rawValue: tickType) {
            switch (eTickType) {
            case .bid_SIZE:                    return "bidSize"
            case .bid:                         return "bidPrice"
            case .ask:                         return "askPrice"
            case .ask_SIZE:                    return "askSize"
            case .last:                        return "lastPrice"
            case .last_SIZE:                   return "lastSize"
            case .high:                        return "high"
            case .low:                         return "low"
            case .volume:                      return "volume"
            case .close:                       return "close"
            case .bid_OPTION:                  return "bidOptComp"
            case .ask_OPTION:                  return "askOptComp"
            case .last_OPTION:                 return "lastOptComp"
            case .model_OPTION:                return "modelOptComp"
            case .open:                        return "open"
            case .low_13_WEEK:                 return "13WeekLow"
            case .high_13_WEEK:                return "13WeekHigh"
            case .low_26_WEEK:                 return "26WeekLow"
            case .high_26_WEEK:                return "26WeekHigh"
            case .low_52_WEEK:                 return "52WeekLow"
            case .high_52_WEEK:                return "52WeekHigh"
            case .avg_VOLUME:                  return "AvgVolume"
            case .open_INTEREST:               return "OpenInterest"
            case .option_HISTORICAL_VOL:       return "OptionHistoricalVolatility"
            case .option_IMPLIED_VOL:          return "OptionImpliedVolatility"
            case .option_BID_EXCH:             return "OptionBidExchStr"
            case .option_ASK_EXCH:             return "OptionAskExchStr"
            case .option_CALL_OPEN_INTEREST:   return "OptionCallOpenInterest"
            case .option_PUT_OPEN_INTEREST:    return "OptionPutOpenInterest"
            case .option_CALL_VOLUME:          return "OptionCallVolume"
            case .option_PUT_VOLUME:           return "OptionPutVolume"
            case .index_FUTURE_PREMIUM:        return "IndexFuturePremium"
            case .bid_EXCH:                    return "bidExch"
            case .ask_EXCH:                    return "askExch"
            case .auction_VOLUME:              return "auctionVolume"
            case .auction_PRICE:               return "auctionPrice"
            case .auction_IMBALANCE:           return "auctionImbalance"
            case .mark_PRICE:                  return "markPrice"
            case .bid_EFP_COMPUTATION:         return "bidEFP"
            case .ask_EFP_COMPUTATION:         return "askEFP"
            case .last_EFP_COMPUTATION:        return "lastEFP"
            case .open_EFP_COMPUTATION:        return "openEFP"
            case .high_EFP_COMPUTATION:        return "highEFP"
            case .low_EFP_COMPUTATION:         return "lowEFP"
            case .close_EFP_COMPUTATION:       return "closeEFP"
            case .last_TIMESTAMP:              return "lastTimestamp"
            case .shortable:                   return "shortable"
            case .fundamental_RATIOS:          return "fundamentals"
            case .rt_VOLUME:                   return "RTVolume"
            case .halted:                      return "halted"
            case .bid_YIELD:                   return "bidYield"
            case .ask_YIELD:                   return "askYield"
            case .last_YIELD:                  return "lastYield"
            case .cust_OPTION_COMPUTATION:     return "custOptComp"
            case .trade_COUNT:                 return "trades"
            case .trade_RATE:                  return "trades/min"
            case .volume_RATE:                 return "volume/min"
            case .last_RTH_TRADE:              return "lastRTHTrade"
            case .regulatory_IMBALANCE:        return "regulatoryImbalance"
            }
        }
        return "unknown"
    }
}

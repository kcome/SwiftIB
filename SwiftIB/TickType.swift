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
        case BID_SIZE   = 0
        case BID        = 1
        case ASK        = 2
        case ASK_SIZE   = 3
        case LAST       = 4
        case LAST_SIZE  = 5
        case HIGH       = 6
        case LOW        = 7
        case VOLUME     = 8
        case CLOSE      = 9
        case BID_OPTION = 10
        case ASK_OPTION = 11
        case LAST_OPTION = 12
        case MODEL_OPTION = 13
        case OPEN         = 14
        case LOW_13_WEEK  = 15
        case HIGH_13_WEEK = 16
        case LOW_26_WEEK  = 17
        case HIGH_26_WEEK = 18
        case LOW_52_WEEK  = 19
        case HIGH_52_WEEK = 20
        case AVG_VOLUME   = 21
        case OPEN_INTEREST = 22
        case OPTION_HISTORICAL_VOL = 23
        case OPTION_IMPLIED_VOL = 24
        case OPTION_BID_EXCH = 25
        case OPTION_ASK_EXCH = 26
        case OPTION_CALL_OPEN_INTEREST = 27
        case OPTION_PUT_OPEN_INTEREST = 28
        case OPTION_CALL_VOLUME = 29
        case OPTION_PUT_VOLUME = 30
        case INDEX_FUTURE_PREMIUM = 31
        case BID_EXCH = 32
        case ASK_EXCH = 33
        case AUCTION_VOLUME = 34
        case AUCTION_PRICE = 35
        case AUCTION_IMBALANCE = 36
        case MARK_PRICE = 37
        case BID_EFP_COMPUTATION  = 38
        case ASK_EFP_COMPUTATION  = 39
        case LAST_EFP_COMPUTATION = 40
        case OPEN_EFP_COMPUTATION = 41
        case HIGH_EFP_COMPUTATION = 42
        case LOW_EFP_COMPUTATION = 43
        case CLOSE_EFP_COMPUTATION = 44
        case LAST_TIMESTAMP = 45
        case SHORTABLE = 46
        case FUNDAMENTAL_RATIOS = 47
        case RT_VOLUME = 48
        case HALTED = 49
        case BID_YIELD = 50
        case ASK_YIELD = 51
        case LAST_YIELD = 52
        case CUST_OPTION_COMPUTATION = 53
        case TRADE_COUNT = 54
        case TRADE_RATE = 55
        case VOLUME_RATE = 56
        case LAST_RTH_TRADE = 57
        case REGULATORY_IMBALANCE = 61
    }   

    class func getField(tickType: Int) -> String {
        
        if let eTickType = TickTypeEnum(rawValue: tickType) {
            switch (eTickType) {
            case .BID_SIZE:                    return "bidSize"
            case .BID:                         return "bidPrice"
            case .ASK:                         return "askPrice"
            case .ASK_SIZE:                    return "askSize"
            case .LAST:                        return "lastPrice"
            case .LAST_SIZE:                   return "lastSize"
            case .HIGH:                        return "high"
            case .LOW:                         return "low"
            case .VOLUME:                      return "volume"
            case .CLOSE:                       return "close"
            case .BID_OPTION:                  return "bidOptComp"
            case .ASK_OPTION:                  return "askOptComp"
            case .LAST_OPTION:                 return "lastOptComp"
            case .MODEL_OPTION:                return "modelOptComp"
            case .OPEN:                        return "open"
            case .LOW_13_WEEK:                 return "13WeekLow"
            case .HIGH_13_WEEK:                return "13WeekHigh"
            case .LOW_26_WEEK:                 return "26WeekLow"
            case .HIGH_26_WEEK:                return "26WeekHigh"
            case .LOW_52_WEEK:                 return "52WeekLow"
            case .HIGH_52_WEEK:                return "52WeekHigh"
            case .AVG_VOLUME:                  return "AvgVolume"
            case .OPEN_INTEREST:               return "OpenInterest"
            case .OPTION_HISTORICAL_VOL:       return "OptionHistoricalVolatility"
            case .OPTION_IMPLIED_VOL:          return "OptionImpliedVolatility"
            case .OPTION_BID_EXCH:             return "OptionBidExchStr"
            case .OPTION_ASK_EXCH:             return "OptionAskExchStr"
            case .OPTION_CALL_OPEN_INTEREST:   return "OptionCallOpenInterest"
            case .OPTION_PUT_OPEN_INTEREST:    return "OptionPutOpenInterest"
            case .OPTION_CALL_VOLUME:          return "OptionCallVolume"
            case .OPTION_PUT_VOLUME:           return "OptionPutVolume"
            case .INDEX_FUTURE_PREMIUM:        return "IndexFuturePremium"
            case .BID_EXCH:                    return "bidExch"
            case .ASK_EXCH:                    return "askExch"
            case .AUCTION_VOLUME:              return "auctionVolume"
            case .AUCTION_PRICE:               return "auctionPrice"
            case .AUCTION_IMBALANCE:           return "auctionImbalance"
            case .MARK_PRICE:                  return "markPrice"
            case .BID_EFP_COMPUTATION:         return "bidEFP"
            case .ASK_EFP_COMPUTATION:         return "askEFP"
            case .LAST_EFP_COMPUTATION:        return "lastEFP"
            case .OPEN_EFP_COMPUTATION:        return "openEFP"
            case .HIGH_EFP_COMPUTATION:        return "highEFP"
            case .LOW_EFP_COMPUTATION:         return "lowEFP"
            case .CLOSE_EFP_COMPUTATION:       return "closeEFP"
            case .LAST_TIMESTAMP:              return "lastTimestamp"
            case .SHORTABLE:                   return "shortable"
            case .FUNDAMENTAL_RATIOS:          return "fundamentals"
            case .RT_VOLUME:                   return "RTVolume"
            case .HALTED:                      return "halted"
            case .BID_YIELD:                   return "bidYield"
            case .ASK_YIELD:                   return "askYield"
            case .LAST_YIELD:                  return "lastYield"
            case .CUST_OPTION_COMPUTATION:     return "custOptComp"
            case .TRADE_COUNT:                 return "trades"
            case .TRADE_RATE:                  return "trades/min"
            case .VOLUME_RATE:                 return "volume/min"
            case .LAST_RTH_TRADE:              return "lastRTHTrade"
            case .REGULATORY_IMBALANCE:        return "regulatoryImbalance"
            default:                          return "unknown"
            }
        }
        return "unknown"
    }
}
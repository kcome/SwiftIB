//
//  ContractDetails.swift
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

class ContractDetails {
    var summary: Contract = Contract()
    var marketName: String
    var minTick: Double = 0
    var priceMagnifier: Int = 0
    var orderTypes: String
    var validExchanges: String
    var underConId: Int = 0
    var longName: String
    var contractMonth: String
    var industry: String
    var category: String
    var subcategory: String
    var timeZoneId: String
    var tradingHours: String
    var liquidHours: String
    var evRule: String
    var evMultiplier: Double = 0
    
    var secIdList: [TagValue]? = nil // CUSIP/ISIN/etc.: Vector
    
    // BOND values
    var cusip: String = ""
    var ratings: String = ""
    var descAppend: String = ""
    var bondType: String = ""
    var couponType: String = ""
    var callable : Bool = false
    var putable : Bool = false
    var coupon : Double = 0
    var convertible : Bool = false
    var maturity: String = ""
    var issueDate: String = ""
    var nextOptionDate: String = ""
    var nextOptionType: String = ""
    var nextOptionPartial: Bool = false
    var notes: String = ""

    init(p_summary: Contract, p_marketName: String, p_minTick: Double, p_orderTypes: String,
        p_validExchanges: String, p_underConId: Int, p_longName: String, p_contractMonth: String,
        p_industry: String, p_category: String, p_subcategory: String, p_timeZoneId: String,
        p_tradingHours: String, p_liquidHours: String, p_evRule: String, p_evMultiplier: Double) {
            summary = p_summary
            marketName = p_marketName
            minTick = p_minTick
            orderTypes = p_orderTypes
            validExchanges = p_validExchanges
            underConId = p_underConId
            longName = p_longName
            contractMonth = p_contractMonth
            industry = p_industry
            category = p_category
            subcategory = p_subcategory
            timeZoneId = p_timeZoneId
            tradingHours = p_tradingHours
            liquidHours = p_liquidHours
            evRule = p_evRule
            evMultiplier = p_evMultiplier
    }
}

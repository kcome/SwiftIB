//
//  ContractDetails.swift
//  SwiftIB
//
//  Created by Hanfei Li on 1/01/2015.
//  Copyright (c) 2015 Hanfei Li. All rights reserved.
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
    var cusip: String? = nil
    var ratings: String? = nil
    var descAppend: String? = nil
    var bondType: String? = nil
    var couponType: String? = nil
    var callable : Bool = false
    var putable : Bool = false
    var coupon : Double = 0
    var convertible : Bool = false
    var maturity: String? = nil
    var issueDate: String? = nil
    var nextOptionDate: String? = nil
    var nextOptionType: String? = nil
    var nextOptionPartial: Bool = false
    var notes: String? = nil

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

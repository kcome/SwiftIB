//
//  Order.swift
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

class Order: Equatable {
    
    let CUSTOMER: Int = 0
    let FIRM: Int = 1
    let OPT_UNKNOWN: Character = "?"
    let OPT_BROKER_DEALER: Character = "b"
    let OPT_CUSTOMER: Character = "c"
    let OPT_FIRM: Character = "f"
    let OPT_ISEMM: Character = "m"
    let OPT_FARMM: Character = "n"
    let OPT_SPECIALIST: Character = "y"
    let AUCTION_MATCH: Int = 1
    let AUCTION_IMPROVEMENT: Int = 2
    let AUCTION_TRANSPARENT: Int = 3
    let EMPTY_STR: String = ""

    // main order fields
    var orderId: Int
    var clientId: Int
    var permId: Int
    var action: String
    var totalQuantity: Int
    var orderType: String
    var lmtPrice: Double
    var auxPrice: Double
    
    // extended order fields
    var tif: String  // "Time in Force" - DAY, GTC, etc.
    var activeStartTime: String // GTC orders
    var activeStopTime: String // GTC orders
    var ocaGroup: String // one cancels all group name
    var ocaType: Int = 0 // 1 = CANCEL_WITH_BLOCK, 2 = REDUCE_WITH_BLOCK, 3 = REDUCE_NON_BLOCK
    var orderRef: String
    var transmit: Bool  // if false, order will be created but not transmited
    var parentId: Int = 0  // Parent order Id, to associate Auto STP or TRAIL orders with the original order.
    var blockOrder: Bool = false
    var sweepToFill: Bool = false
    var displaySize: Int = 0
    var triggerMethod: Int = 0 // 0=Default, 1=Double_Bid_Ask, 2=Last, 3=Double_Last, 4=Bid_Ask, 7=Last_or_Bid_Ask, 8=Mid-point
    var outsideRth: Bool
    var hidden: Bool = false
    var goodAfterTime: String // FORMAT: 20060505 08:00:00 {time zone}
    var goodTillDate: String  // FORMAT: 20060505 08:00:00 {time zone}
    var overridePercentageConstraints: Bool = false
    var rule80A: String  // Individual = 'I', Agency = 'A', AgentOtherMember = 'W', IndividualPTIA = 'J', AgencyPTIA = 'U', AgentOtherMemberPTIA = 'M', IndividualPT = 'K', AgencyPT = 'Y', AgentOtherMemberPT = 'N'
    var allOrNone: Bool = false
    var minQty: Int
    var percentOffset: Double    // REL orders only. specify the decimal, e.g. .04 not 4
    var trailStopPrice: Double   // for TRAILLIMIT orders only
    var trailingPercent: Double  // specify the percentage, e.g. 3, not .03
    
    // Financial advisors only
    var faGroup: String
    var faProfile: String
    var faMethod: String
    var faPercentage: String
    
    // Institutional orders only
    var openClose: String          // O=Open, C=Close
    var origin: Int             // 0=Customer, 1=Firm
    var shortSaleSlot: Int = 0     // 1 if you hold the shares, 2 if they will be delivered from elsewhere.  Only for Action="SSHORT
    var designatedLocation: String // set when slot=2 only.
    var exemptCode: Int
    
    // SMART routing only
    var discretionaryAmt: Double = 0
    var eTradeOnly: Bool = false
    var firmQuoteOnly: Bool = false
    var nbboPriceCap: Double
    var optOutSmartRouting: Bool
    
    // BOX or VOL ORDERS ONLY
    var auctionStrategy: Int = 0 // 1=AUCTION_MATCH, 2=AUCTION_IMPROVEMENT, 3=AUCTION_TRANSPARENT
    
    // BOX ORDERS ONLY
    var startingPrice: Double
    var stockRefPrice: Double
    var delta: Double
    
    // pegged to stock or VOL orders
    var stockRangeLower: Double
    var stockRangeUpper: Double
    
    // VOLATILITY ORDERS ONLY
    var volatility: Double  // enter percentage not decimal, e.g. 2 not .02
    var volatilityType: Int     // 1=daily, 2=annual
    var continuousUpdate: Int = 0
    var referencePriceType: Int // 1=Bid/Ask midpoint, 2 = BidOrAsk
    var deltaNeutralOrderType: String
    var deltaNeutralAuxPrice: Double
    var deltaNeutralConId: Int
    var deltaNeutralSettlingFirm: String
    var deltaNeutralClearingAccount: String
    var deltaNeutralClearingIntent: String
    var deltaNeutralOpenClose: String
    var deltaNeutralShortSale: Bool
    var deltaNeutralShortSaleSlot: Int
    var deltaNeutralDesignatedLocation: String
    
    // COMBO ORDERS ONLY
    var basisPoints: Double      // EFP orders only, download only
    var basisPointsType: Int  // EFP orders only, download only
    
    // SCALE ORDERS ONLY
    var scaleInitLevelSize: Int
    var scaleSubsLevelSize: Int
    var scalePriceIncrement: Double
    var scalePriceAdjustValue: Double
    var scalePriceAdjustInterval: Int
    var scaleProfitOffset: Double
    var scaleAutoReset: Bool
    var scaleInitPosition: Int
    var scaleInitFillQty: Int
    var scaleRandomPercent: Bool
    var scaleTable: String
    
    // HEDGE ORDERS ONLY
    var hedgeType: String // 'D' - delta, 'B' - beta, 'F' - FX, 'P' - pair
    var hedgeParam: String // beta value for beta hedge (in range 0-1), ratio for pair hedge
    
    // Clearing info
    var account: String // IB account
    var settlingFirm: String
    var clearingAccount: String // True beneficiary of the order
    var clearingIntent: String // "" (Default), "IB", "Away", "PTA" (PostTrade)
    
    // ALGO ORDERS ONLY
    var algoStrategy: String
    var algoParams: [TagValue] = [TagValue]()
    
    // What-if
    var whatIf: Bool
    
    // Not Held
    var notHeld: Bool
    
    // Smart combo routing params
    var smartComboRoutingParams: [TagValue] = [TagValue]()
    
    // order combo legs
    var orderComboLegs: [OrderComboLeg] = [OrderComboLeg]()
    
    // order misc options
    var orderMiscOptions: [TagValue] = [TagValue]()
    
    init() {
        activeStartTime = EMPTY_STR
        activeStopTime = EMPTY_STR
        designatedLocation = EMPTY_STR
        deltaNeutralOrderType = EMPTY_STR
        deltaNeutralSettlingFirm = EMPTY_STR
        deltaNeutralClearingAccount = EMPTY_STR
        deltaNeutralClearingIntent = EMPTY_STR
        deltaNeutralOpenClose = EMPTY_STR
        deltaNeutralDesignatedLocation = EMPTY_STR
        scaleTable = EMPTY_STR

        openClose = "O"
        origin = CUSTOMER
        transmit = true
        exemptCode = -1
        deltaNeutralConId = 0
        deltaNeutralShortSaleSlot = 0

        lmtPrice = Double.NaN
        auxPrice = Double.NaN
        percentOffset = Double.NaN
        nbboPriceCap = Double.NaN
        startingPrice = Double.NaN
        stockRefPrice = Double.NaN
        delta = Double.NaN
        stockRangeLower = Double.NaN
        stockRangeUpper = Double.NaN
        volatility = Double.NaN
        deltaNeutralAuxPrice = Double.NaN
        trailStopPrice = Double.NaN
        trailingPercent = Double.NaN
        basisPoints = Double.NaN
        scalePriceIncrement = Double.NaN
        scalePriceAdjustValue = Double.NaN
        scaleProfitOffset = Double.NaN
        
        minQty = Int.max
        volatilityType = Int.max
        referencePriceType = Int.max
        basisPointsType = Int.max
        scaleInitLevelSize = Int.max
        scaleSubsLevelSize = Int.max
        scalePriceAdjustInterval = Int.max
        scaleInitPosition = Int.max
        scaleInitFillQty = Int.max
        
        outsideRth = false
        optOutSmartRouting = false
        deltaNeutralShortSale = false
        scaleAutoReset = false
        scaleRandomPercent = false
        whatIf = false
        notHeld = false
        
        orderId = 0
        clientId = 0
        permId = 0
        action = EMPTY_STR
        totalQuantity = 0
        orderType = EMPTY_STR
        
        tif = EMPTY_STR
        ocaGroup = EMPTY_STR
        orderRef = EMPTY_STR
        goodAfterTime = EMPTY_STR
        goodTillDate = EMPTY_STR
        rule80A = EMPTY_STR
        faGroup = EMPTY_STR
        faProfile = EMPTY_STR
        faMethod = EMPTY_STR
        faPercentage = EMPTY_STR
        hedgeType = EMPTY_STR
        hedgeParam = EMPTY_STR
        account = EMPTY_STR
        settlingFirm = EMPTY_STR
        clearingAccount = EMPTY_STR
        clearingIntent = EMPTY_STR
        algoStrategy = EMPTY_STR
        
    }
}

func == (lhs: Order, rhs: Order) -> Bool {
    if lhs === rhs {
        return true
    }
    
    if lhs.permId == rhs.permId {
        return true
    }

    if lhs.orderId != rhs.orderId {return false}
    if lhs.clientId != rhs.clientId {return false}
    if lhs.totalQuantity != rhs.totalQuantity {return false}
    if lhs.lmtPrice != rhs.lmtPrice {return false}
    if lhs.auxPrice != rhs.auxPrice {return false}
    if lhs.ocaType != rhs.ocaType {return false}
    if lhs.transmit != rhs.transmit {return false}
    if lhs.parentId != rhs.parentId {return false}
    if lhs.blockOrder != rhs.blockOrder {return false}
    if lhs.sweepToFill != rhs.sweepToFill {return false}
    if lhs.displaySize != rhs.displaySize {return false}
    if lhs.triggerMethod != rhs.triggerMethod {return false}
    if lhs.outsideRth != rhs.outsideRth {return false}
    if lhs.hidden != rhs.hidden {return false}
    if lhs.overridePercentageConstraints != rhs.overridePercentageConstraints {return false}
    if lhs.allOrNone != rhs.allOrNone {return false}
    if lhs.minQty != rhs.minQty {return false}
    if lhs.percentOffset != rhs.percentOffset {return false}
    if lhs.trailStopPrice != rhs.trailStopPrice {return false}
    if lhs.trailingPercent != rhs.trailingPercent {return false}
    if lhs.origin != rhs.origin {return false}
    if lhs.shortSaleSlot != rhs.shortSaleSlot {return false}
    if lhs.discretionaryAmt != rhs.discretionaryAmt {return false}
    if lhs.eTradeOnly != rhs.eTradeOnly {return false}
    if lhs.firmQuoteOnly != rhs.firmQuoteOnly {return false}
    if lhs.nbboPriceCap != rhs.nbboPriceCap {return false}
    if lhs.optOutSmartRouting != rhs.optOutSmartRouting {return false}
    if lhs.auctionStrategy != rhs.auctionStrategy {return false}
    if lhs.startingPrice != rhs.startingPrice {return false}
    if lhs.stockRefPrice != rhs.stockRefPrice {return false}
    if lhs.delta != rhs.delta {return false}
    if lhs.stockRangeLower != rhs.stockRangeLower {return false}
    if lhs.stockRangeUpper != rhs.stockRangeUpper {return false}
    if lhs.volatility != rhs.volatility {return false}
    if lhs.volatilityType != rhs.volatilityType {return false}
    if lhs.continuousUpdate != rhs.continuousUpdate {return false}
    if lhs.referencePriceType != rhs.referencePriceType {return false}
    if lhs.deltaNeutralAuxPrice != rhs.deltaNeutralAuxPrice {return false}
    if lhs.deltaNeutralConId != rhs.deltaNeutralConId {return false}
    if lhs.deltaNeutralShortSale != rhs.deltaNeutralShortSale {return false}
    if lhs.deltaNeutralShortSaleSlot != rhs.deltaNeutralShortSaleSlot {return false}
    if lhs.basisPoints != rhs.basisPoints {return false}
    if lhs.basisPointsType != rhs.basisPointsType {return false}
    if lhs.scaleInitLevelSize != rhs.scaleInitLevelSize {return false}
    if lhs.scaleSubsLevelSize != rhs.scaleSubsLevelSize {return false}
    if lhs.scalePriceIncrement != rhs.scalePriceIncrement {return false}
    if lhs.scalePriceAdjustValue != rhs.scalePriceAdjustValue {return false}
    if lhs.scalePriceAdjustInterval != rhs.scalePriceAdjustInterval {return false}
    if lhs.scaleProfitOffset != rhs.scaleProfitOffset {return false}
    if lhs.scaleAutoReset != rhs.scaleAutoReset {return false}
    if lhs.scaleInitPosition != rhs.scaleInitPosition {return false}
    if lhs.scaleInitFillQty != rhs.scaleInitFillQty {return false}
    if lhs.scaleRandomPercent != rhs.scaleRandomPercent {return false}
    if lhs.whatIf != rhs.whatIf {return false}
    if lhs.notHeld != rhs.notHeld {return false}
    if lhs.exemptCode != rhs.exemptCode {return false}

    if lhs.action != rhs.action {return false}
    if lhs.orderType != rhs.orderType {return false}
    if lhs.tif != rhs.tif {return false}
    if lhs.activeStartTime != rhs.activeStartTime {return false}
    if lhs.activeStopTime != rhs.activeStopTime {return false}
    if lhs.ocaGroup != rhs.ocaGroup {return false}
    if lhs.orderRef != rhs.orderRef {return false}
    if lhs.goodAfterTime != rhs.goodAfterTime {return false}
    if lhs.goodTillDate != rhs.goodTillDate {return false}
    if lhs.rule80A != rhs.rule80A {return false}
    if lhs.faGroup != rhs.faGroup {return false}
    if lhs.faProfile != rhs.faProfile {return false}
    if lhs.faMethod != rhs.faMethod {return false}
    if lhs.faPercentage != rhs.faPercentage {return false}
    if lhs.openClose != rhs.openClose {return false}
    if lhs.designatedLocation != rhs.designatedLocation {return false}
    if lhs.deltaNeutralOrderType != rhs.deltaNeutralOrderType {return false}
    if lhs.deltaNeutralSettlingFirm != rhs.deltaNeutralSettlingFirm {return false}
    if lhs.deltaNeutralClearingAccount != rhs.deltaNeutralClearingAccount {return false}
    if lhs.deltaNeutralClearingIntent != rhs.deltaNeutralClearingIntent {return false}
    if lhs.deltaNeutralOpenClose != rhs.deltaNeutralOpenClose {return false}
    if lhs.deltaNeutralDesignatedLocation != rhs.deltaNeutralDesignatedLocation {return false}
    if lhs.hedgeType != rhs.hedgeType {return false}
    if lhs.hedgeParam != rhs.hedgeParam {return false}
    if lhs.account != rhs.account {return false}
    if lhs.settlingFirm != rhs.settlingFirm {return false}
    if lhs.clearingAccount != rhs.clearingAccount {return false}
    if lhs.clearingIntent != rhs.clearingIntent {return false}
    if lhs.algoStrategy != rhs.algoStrategy {return false}
    if lhs.scaleTable != rhs.scaleTable {return false}
    
    if !arrayEqualUnordered(lhs.algoParams, rhs.algoParams) {return false}
    if !arrayEqualUnordered(lhs.smartComboRoutingParams, rhs.smartComboRoutingParams) {return false}
    if !arrayEqualUnordered(lhs.orderComboLegs, rhs.orderComboLegs) {return false}
    
    return true
}

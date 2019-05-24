//
//  EReader.swift
//  SwiftIB
//
//  Created by Harry Li on 3/01/2015.
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

class EReader: Thread {

    // incoming msg id's
    enum MsgIdEnum: Int {
        case tick_PRICE     = 1
        case tick_SIZE      = 2
        case order_STATUS   = 3
        case err_MSG        = 4
        case open_ORDER         = 5
        case acct_VALUE         = 6
        case portfolio_VALUE    = 7
        case acct_UPDATE_TIME   = 8
        case next_VALID_ID      = 9
        case contract_DATA      = 10
        case execution_DATA     = 11
        case market_DEPTH       = 12
        case market_DEPTH_L2    = 13
        case news_BULLETINS     = 14
        case managed_ACCTS      = 15
        case receive_FA         = 16
        case historical_DATA    = 17
        case bond_CONTRACT_DATA = 18
        case scanner_PARAMETERS = 19
        case scanner_DATA       = 20
        case tick_OPTION_COMPUTATION = 21
        case tick_GENERIC = 45
        case tick_STRING = 46
        case tick_EFP = 47
        case current_TIME = 49
        case real_TIME_BARS = 50
        case fundamental_DATA = 51
        case contract_DATA_END = 52
        case open_ORDER_END = 53
        case acct_DOWNLOAD_END = 54
        case execution_DATA_END = 55
        case delta_NEUTRAL_VALIDATION = 56
        case tick_SNAPSHOT_END = 57
        case market_DATA_TYPE = 58
        case commission_REPORT = 59
        case position = 61
        case position_END = 62
        case account_SUMMARY = 63
        case account_SUMMARY_END = 64
        case verify_MESSAGE_API = 65
        case verify_COMPLETED = 66
        case display_GROUP_LIST = 67
        case display_GROUP_UPDATED = 68
    }

    var _parent: EClientSocket
    var dis: InputStream
    
    var parent: EClientSocket {
        return _parent
    }
    
    var eWrapper: EWrapper {
        return _parent.eWrapper()
    }
    
    convenience init(parent: EClientSocket, dis: InputStream) {
        self.init(p_name:"", p_parent:parent, p_dis:dis)
    }
    
    init(p_name: String, p_parent: EClientSocket, p_dis: InputStream) {
        _parent = p_parent
        dis = p_dis

        super.init()

        self.name = p_name
    }
    
    override func main() {
        // loop until thread is terminated
        while (self.isExecuting && processMsg(readInt())) {
        }
        if (_parent.isConnected()) {
            _parent.close()
        }
        dis.close()
    }
    
    func readStr() -> String {
        var buf = ""
        var bytes = Array<UInt8>(repeating: 0, count: 1)
        while (true) {
            let read = dis.read(&bytes, maxLength: 1)
            if read == 0 || bytes[0] == 0 { break }
            if let s = String(bytes: bytes, encoding: String.Encoding.utf8) {
                buf += s
            }
            if dis.hasBytesAvailable == false { break }
        }
        return buf
    }

    func readBoolFromInt() -> Bool {
        let str = readStr()
        return str.utf16.count == 0 ? false : (Int(str) != 0)
    }
    
    func readInt() -> Int {
        let str = readStr()
        if str.utf16.count == 0 {return 0}
        else if let i = Int(str) { return i }
        else {return 0}
    }
    
    func readIntMax() -> Int {
        let str = readStr()
        if str.utf16.count == 0 {return Int.max}
        else if let i = Int(str) { return i }
        else {return Int.max}
    }
    
    func readLong() -> Int64 {
        let str = readStr()
        if str.utf16.count == 0 {return 0}
        let ni = NSString(string: str)
        return ni.longLongValue
    }
    
    func readDouble() -> Double {
        let str = readStr()
        if str.utf16.count == 0 {return 0}
        let ni = NSString(string: str)
        return ni.doubleValue
    }
    
    func readDoubleMax() -> Double {
        let str = readStr()
        if str.utf16.count == 0 {return Double.nan}
        let ni = NSString(string: str)
        return ni.doubleValue
    }
    
    func processMsg(_ msgId: Int) -> Bool {
        if msgId == -1 {return false}
        
        if let msg = MsgIdEnum(rawValue: msgId) {
            switch (msg) {
            case .tick_PRICE:
                let version = readInt()
                let tickerId = readInt()
                let tickType = readInt()
                let price = readDouble()
                var size = 0
                if (version >= 2) {
                    size = readInt()
                }
                var canAutoExecute = 0
                if (version >= 3) {
                    canAutoExecute = readInt()
                }
                self.eWrapper.tickPrice(tickerId, field: tickType, price: price, canAutoExecute: canAutoExecute)
                
                if (version >= 2) {
                    var sizeTickType = -1  // not a tick
                    switch (tickType) {
                    case 1: // BID
                        sizeTickType = 0  // BID_SIZE
                    case 2: // ASK
                        sizeTickType = 3  // ASK_SIZE
                    case 4: // LAST
                        sizeTickType = 5  // LAST_SIZE
                    default:
                        sizeTickType = -1  // not a tick
                    }
                    if (sizeTickType != -1) {
                        self.eWrapper.tickSize(tickerId, field: sizeTickType, size: size)
                    }
                }
                
            case .tick_SIZE:
                _ = readInt()
                let tickerId = readInt()
                let tickType = readInt()
                let size = readInt()
                
                self.eWrapper.tickSize(tickerId, field: tickType, size: size)
                
            case .position:
                let version = readInt()
                let account = readStr()
                
                let contract = Contract()
                contract.conId = readInt()
                contract.symbol = readStr()
                contract.secType = readStr()
                contract.expiry = readStr()
                contract.strike = readDouble()
                contract.right = readStr()
                contract.multiplier = readStr()
                contract.exchange = readStr()
                contract.currency = readStr()
                contract.localSymbol = readStr()
                if (version >= 2) {
                    contract.tradingClass = readStr()
                }
                
                let pos = readInt()
                var avgCost = 0.0
                if (version >= 3) {
                    avgCost = readDouble()
                }
                
                self.eWrapper.position(account, contract: contract, pos: pos, avgCost: avgCost)
                
            case .position_END:
                _ = readInt()
                self.eWrapper.positionEnd()
                
            case .account_SUMMARY:
                _ = readInt()
                let reqId = readInt()
                let account = readStr()
                let tag = readStr()
                let value = readStr()
                let currency = readStr()
                self.eWrapper.accountSummary(reqId, account: account, tag: tag, value: value, currency: currency)
                
            case .account_SUMMARY_END:
                _ = readInt()
                let reqId = readInt()
                self.eWrapper.accountSummaryEnd(reqId)
                
            case .tick_OPTION_COMPUTATION:
                let version = readInt()
                let tickerId = readInt()
                let tickType = readInt()
                var impliedVol = readDouble()
                if (impliedVol < 0) { // -1 is the "not yet computed" indicator
                    impliedVol = Double.nan
                }
                var delta = readDouble()
                if (abs(delta) > 1) { // -2 is the "not yet computed" indicator
                    delta = Double.nan
                }
                var optPrice = Double.nan
                var pvDividend = Double.nan
                var gamma = Double.nan
                var vega = Double.nan
                var theta = Double.nan
                var undPrice = Double.nan
                if (version >= 6 || TickType.TickTypeEnum(rawValue: tickType)! == .model_OPTION) { // introduced in version == 5
                    optPrice = readDouble()
                    if (optPrice < 0) { // -1 is the "not yet computed" indicator
                        optPrice = Double.nan
                    }
                    pvDividend = readDouble()
                    if (pvDividend < 0) { // -1 is the "not yet computed" indicator
                        pvDividend = Double.nan
                    }
                }
                if (version >= 6) {
                    gamma = readDouble()
                    if (abs(gamma) > 1) { // -2 is the "not yet computed" indicator
                        gamma = Double.nan
                    }
                    vega = readDouble()
                    if (abs(vega) > 1) { // -2 is the "not yet computed" indicator
                        vega = Double.nan
                    }
                    theta = readDouble()
                    if (abs(theta) > 1) { // -2 is the "not yet computed" indicator
                        theta = Double.nan
                    }
                    undPrice = readDouble()
                    if (undPrice < 0) { // -1 is the "not yet computed" indicator
                        undPrice = Double.nan
                    }
                }
                
                self.eWrapper.tickOptionComputation(tickerId, field: tickType, impliedVol: impliedVol, delta: delta, optPrice: optPrice, pvDividend:pvDividend, gamma: gamma, vega: vega, theta: theta, undPrice: undPrice)
                
            case .tick_GENERIC:
                _ = readInt()
                let tickerId = readInt()
                let tickType = readInt()
                let value = readDouble()
                
                self.eWrapper.tickGeneric(tickerId, tickType: tickType, value: value)
                
            case .tick_STRING:
                _ = readInt()
                let tickerId = readInt()
                let tickType = readInt()
                let value = readStr()
                
                self.eWrapper.tickString(tickerId, tickType: tickType, value: value)
                
            case .tick_EFP:
                let _ = readInt()
                let tickerId = readInt()
                let tickType = readInt()
                let basisPoints = readDouble()
                let formattedBasisPoints = readStr()
                let impliedFuturesPrice = readDouble()
                let holdDays = readInt()
                let futureExpiry = readStr()
                let dividendImpact = readDouble()
                let dividendsToExpiry = readDouble()
                self.eWrapper.tickEFP(tickerId, tickType: tickType, basisPoints: basisPoints, formattedBasisPoints: formattedBasisPoints,
                    impliedFuture: impliedFuturesPrice, holdDays: holdDays, futureExpiry: futureExpiry, dividendImpact: dividendImpact, dividendsToExpiry: dividendsToExpiry)
                
            case .order_STATUS:
                let version = readInt()
                let id = readInt()
                let status = readStr()
                let filled = readInt()
                let remaining = readInt()
                let avgFillPrice = readDouble()
                
                var permId = 0
                if( version >= 2) {
                    permId = readInt()
                }
                
                var parentId = 0
                if( version >= 3) {
                    parentId = readInt()
                }
                
                var lastFillPrice = 0.0
                if( version >= 4) {
                    lastFillPrice = readDouble()
                }
                
                var clientId = 0
                if( version >= 5) {
                    clientId = readInt()
                }
                
                var whyHeld = ""
                if( version >= 6) {
                    whyHeld = readStr()
                }
                
                self.eWrapper.orderStatus(id, status: status, filled: filled, remaining: remaining, avgFillPrice: avgFillPrice,
                    permId: permId, parentId: parentId, lastFillPrice: lastFillPrice, clientId: clientId, whyHeld: whyHeld)
                
            case .acct_VALUE:
                let version = readInt()
                let key = readStr()
                let val  = readStr()
                let cur = readStr()
                var accountName = ""
                if( version >= 2) {
                    accountName = readStr()
                }
                self.eWrapper.updateAccountValue(key, value: val, currency: cur, accountName: accountName)
                
            case .portfolio_VALUE:
                let version = readInt()
                let contract = Contract()
                if (version >= 6) {
                    contract.conId = readInt()
                }
                contract.symbol  = readStr()
                contract.secType = readStr()
                contract.expiry  = readStr()
                contract.strike  = readDouble()
                contract.right   = readStr()
                if (version >= 7) {
                    contract.multiplier = readStr()
                    contract.primaryExch = readStr()
                }
                contract.currency = readStr()
                if (version >= 2 ) {
                    contract.localSymbol = readStr()
                }
                if (version >= 8) {
                    contract.tradingClass = readStr()
                }
                
                let position  = readInt()
                let marketPrice = readDouble()
                let marketValue = readDouble()
                var averageCost = 0.0
                var unrealizedPNL = 0.0
                var realizedPNL = 0.0
                if version >= 3 {
                    averageCost = readDouble()
                    unrealizedPNL = readDouble()
                    realizedPNL = readDouble()
                }
                
                var accountName = ""
                if( version >= 4) {
                    accountName = readStr()
                }
                
                if(version == 6 && _parent.serverVersion() == 39) {
                    contract.primaryExch = readStr()
                }
                
                self.eWrapper.updatePortfolio(contract, position: position, marketPrice: marketPrice, marketValue: marketValue,
                    averageCost: averageCost, unrealizedPNL: unrealizedPNL, realizedPNL: realizedPNL, accountName: accountName)
                
                
            case .acct_UPDATE_TIME:
                _ = readInt()
                let timeStamp = readStr()
                self.eWrapper.updateAccountTime(timeStamp)
                
            case .err_MSG:
                let version = readInt()
                if(version < 2) {
                    let msg = readStr()
                    _parent.error(-1, errorCode: -1, errorMsg: msg)
                } else {
                    let id = readInt()
                    let errorCode    = readInt()
                    let errorMsg = readStr()
                    _parent.error(id, errorCode: errorCode, errorMsg: errorMsg)
                }
                
            case .open_ORDER:
                // read version
                let version = readInt()
                
                // read order id
                let order = Order()
                order.orderId = readInt()
                
                // read contract fields
                let contract = Contract()
                if (version >= 17) {
                    contract.conId = readInt()
                }
                contract.symbol = readStr()
                contract.secType = readStr()
                contract.expiry = readStr()
                contract.strike = readDouble()
                contract.right = readStr()
                if (version >= 32) {
                    contract.multiplier = readStr()
                }
                contract.exchange = readStr()
                contract.currency = readStr()
                if (version >= 2 ) {
                    contract.localSymbol = readStr()
                }
                if (version >= 32) {
                    contract.tradingClass = readStr()
                }
                
                // read order fields
                order.action = readStr()
                order.totalQuantity = readInt()
                order.orderType = readStr()
                if (version < 29) {
                    order.lmtPrice = readDouble()
                }
                else {
                    order.lmtPrice = readDoubleMax()
                }
                if (version < 30) {
                    order.auxPrice = readDouble()
                }
                else {
                    order.auxPrice = readDoubleMax()
                }
                order.tif = readStr()
                order.ocaGroup = readStr()
                order.account = readStr()
                order.openClose = readStr()
                order.origin = readInt()
                order.orderRef = readStr()
                
                if(version >= 3) {
                    order.clientId = readInt()
                }
                
                if( version >= 4 ) {
                    order.permId = readInt()
                    if (version < 18) {
                        // will never happen
                        let _ = readBoolFromInt()
                    }
                    else {
                        order.outsideRth = readBoolFromInt()
                    }
                    order.hidden = readInt() == 1
                    order.discretionaryAmt = readDouble()
                }
                
                if (version >= 5 ) {
                    order.goodAfterTime = readStr()
                }
                
                if (version >= 6 ) {
                    // skip deprecated sharesAllocation field
                    let _ = readStr()
                }
                
                if (version >= 7 ) {
                    order.faGroup = readStr()
                    order.faMethod = readStr()
                    order.faPercentage = readStr()
                    order.faProfile = readStr()
                }
                
                if (version >= 8 ) {
                    order.goodTillDate = readStr()
                }
                
                if (version >= 9) {
                    order.rule80A = readStr()
                    order.percentOffset = readDoubleMax()
                    order.settlingFirm = readStr()
                    order.shortSaleSlot = readInt()
                    order.designatedLocation = readStr()
                    if (_parent.serverVersion() == 51) {
                        let _ = readInt() // exemptCode
                    }
                    else if (version >= 23) {
                        order.exemptCode = readInt()
                    }
                    order.auctionStrategy = readInt()
                    order.startingPrice = readDoubleMax()
                    order.stockRefPrice = readDoubleMax()
                    order.delta = readDoubleMax()
                    order.stockRangeLower = readDoubleMax()
                    order.stockRangeUpper = readDoubleMax()
                    order.displaySize = readInt()
                    if (version < 18) {
                        // will never happen
                        let _ = readBoolFromInt()
                    }
                    order.blockOrder = readBoolFromInt()
                    order.sweepToFill = readBoolFromInt()
                    order.allOrNone = readBoolFromInt()
                    order.minQty = readIntMax()
                    order.ocaType = readInt()
                    order.eTradeOnly = readBoolFromInt()
                    order.firmQuoteOnly = readBoolFromInt()
                    order.nbboPriceCap = readDoubleMax()
                }
                
                if (version >= 10) {
                    order.parentId = readInt()
                    order.triggerMethod = readInt()
                }
                
                if (version >= 11) {
                    order.volatility = readDoubleMax()
                    order.volatilityType = readInt()
                    if (version == 11) {
                        let receivedInt = readInt()
                        order.deltaNeutralOrderType = ((receivedInt == 0) ? "NONE" : "MKT" )
                    } else { // version 12 and up
                        order.deltaNeutralOrderType = readStr()
                        order.deltaNeutralAuxPrice = readDoubleMax()
                        
                        if (version >= 27 && !order.deltaNeutralOrderType.isEmpty) {
                            order.deltaNeutralConId = readInt()
                            order.deltaNeutralSettlingFirm = readStr()
                            order.deltaNeutralClearingAccount = readStr()
                            order.deltaNeutralClearingIntent = readStr()
                        }
                        
                        if (version >= 31 && !order.deltaNeutralOrderType.isEmpty) {
                            order.deltaNeutralOpenClose = readStr()
                            order.deltaNeutralShortSale = readBoolFromInt()
                            order.deltaNeutralShortSaleSlot = readInt()
                            order.deltaNeutralDesignatedLocation = readStr()
                        }
                    }
                    order.continuousUpdate = readInt()
                    if (_parent.serverVersion() == 26) {
                        order.stockRangeLower = readDouble()
                        order.stockRangeUpper = readDouble()
                    }
                    order.referencePriceType = readInt()
                }
                
                if (version >= 13) {
                    order.trailStopPrice = readDoubleMax()
                }
                
                if (version >= 30) {
                    order.trailingPercent = readDoubleMax()
                }
                
                if (version >= 14) {
                    order.basisPoints = readDoubleMax()
                    order.basisPointsType = readIntMax()
                    contract.comboLegsDescrip = readStr()
                }
                
                if (version >= 29) {
                    let comboLegsCount = readInt()
                    if (comboLegsCount > 0) {
                        contract.comboLegs = [ComboLeg]()
                        for _ in 1...comboLegsCount {
                            let conId = readInt()
                            let ratio = readInt()
                            let action = readStr()
                            let exchange = readStr()
                            let openClose = readInt()
                            let shortSaleSlot = readInt()
                            let designatedLocation = readStr()
                            let exemptCode = readInt()
                            
                            let comboLeg = ComboLeg(p_conId: conId, p_ratio: ratio, p_action: action, p_exchange: exchange, p_openClose: openClose, p_shortSaleSlot: shortSaleSlot, p_designatedLocation: designatedLocation, p_exemptCode: exemptCode)
                            contract.comboLegs.append(comboLeg)
                        }
                    }
                    
                    let orderComboLegsCount = readInt()
                    if (orderComboLegsCount > 0) {
                        order.orderComboLegs = [OrderComboLeg]()
                        for _ in 1...orderComboLegsCount {
                            let price = readDoubleMax()
                            
                            let orderComboLeg = OrderComboLeg(p_price: price)
                            order.orderComboLegs.append(orderComboLeg)
                        }
                    }
                }
                
                if (version >= 26) {
                    let smartComboRoutingParamsCount = readInt()
                    if (smartComboRoutingParamsCount > 0) {
                        order.smartComboRoutingParams = [TagValue]()
                        for _ in 1...smartComboRoutingParamsCount {
                            let tagValue = TagValue()
                            tagValue.tag = readStr()
                            tagValue.value = readStr()
                            order.smartComboRoutingParams.append(tagValue)
                        }
                    }
                }
                
                if (version >= 15) {
                    if (version >= 20) {
                        order.scaleInitLevelSize = readIntMax()
                        order.scaleSubsLevelSize = readIntMax()
                    }
                    else {
                        _ = readIntMax()
                        order.scaleInitLevelSize = readIntMax()
                    }
                    order.scalePriceIncrement = readDoubleMax()
                }
                
                if (version >= 28 && order.scalePriceIncrement > 0.0 && order.scalePriceIncrement != Double.nan) {
                    order.scalePriceAdjustValue = readDoubleMax()
                    order.scalePriceAdjustInterval = readIntMax()
                    order.scaleProfitOffset = readDoubleMax()
                    order.scaleAutoReset = readBoolFromInt()
                    order.scaleInitPosition = readIntMax()
                    order.scaleInitFillQty = readIntMax()
                    order.scaleRandomPercent = readBoolFromInt()
                }
                
                if (version >= 24) {
                    order.hedgeType = readStr()
                    if (!order.hedgeType.isEmpty) {
                        order.hedgeParam = readStr()
                    }
                }
                
                if (version >= 25) {
                    order.optOutSmartRouting = readBoolFromInt()
                }
                
                if (version >= 19) {
                    order.clearingAccount = readStr()
                    order.clearingIntent = readStr()
                }
                
                if (version >= 22) {
                    order.notHeld = readBoolFromInt()
                }
                
                if (version >= 20) {
                    if (readBoolFromInt()) {
                        let underComp = UnderComp()
                        underComp.conId = readInt()
                        underComp.delta = readDouble()
                        underComp.price = readDouble()
                        contract.underComp = underComp
                    }
                }
                
                if (version >= 21) {
                    order.algoStrategy = readStr()
                    if (!order.algoStrategy.isEmpty) {
                        let algoParamsCount = readInt()
                        if (algoParamsCount > 0) {
                            order.algoParams = [TagValue]()
                            for _ in 1...algoParamsCount {
                                let tagValue = TagValue()
                                tagValue.tag = readStr()
                                tagValue.value = readStr()
                                order.algoParams.append(tagValue)
                            }
                        }
                    }
                }
                
                let orderState = OrderState(p_status: "", p_initMargin: "", p_maintMargin: "", p_equityWithLoan: "", p_commission: 0, p_minCommission: 0, p_maxCommission: 0, p_commissionCurrency: "", p_warningText: "")
                
                if (version >= 16) {
                    
                    order.whatIf = readBoolFromInt()
                    
                    orderState.status = readStr()
                    orderState.initMargin = readStr()
                    orderState.maintMargin = readStr()
                    orderState.equityWithLoan = readStr()
                    orderState.commission = readDoubleMax()
                    orderState.minCommission = readDoubleMax()
                    orderState.maxCommission = readDoubleMax()
                    orderState.commissionCurrency = readStr()
                    orderState.warningText = readStr()
                }
                
                self.eWrapper.openOrder( order.orderId, contract: contract, order: order, orderState: orderState)
                
            case .next_VALID_ID:
                _ = readInt()
                let orderId = readInt()
                self.eWrapper.nextValidId( orderId)
                
            case .scanner_DATA:
                let contract = ContractDetails(p_summary: Contract(), p_marketName: "", p_minTick: 0, p_orderTypes: "", p_validExchanges: "", p_underConId: 0, p_longName: "", p_contractMonth: "", p_industry: "", p_category: "", p_subcategory: "", p_timeZoneId: "", p_tradingHours: "", p_liquidHours: "", p_evRule: "", p_evMultiplier: 0)
                let version = readInt()
                let tickerId = readInt()
                let numberOfElements = readInt()
                for _ in 1...numberOfElements {
                    let rank = readInt()
                    if (version >= 3) {
                        contract.summary.conId = readInt()
                    }
                    contract.summary.symbol = readStr()
                    contract.summary.secType = readStr()
                    contract.summary.expiry = readStr()
                    contract.summary.strike = readDouble()
                    contract.summary.right = readStr()
                    contract.summary.exchange = readStr()
                    contract.summary.currency = readStr()
                    contract.summary.localSymbol = readStr()
                    contract.marketName = readStr()
                    contract.summary.tradingClass = readStr()
                    let distance = readStr()
                    let benchmark = readStr()
                    let projection = readStr()
                    var legsStr = ""
                    if (version >= 2) {
                        legsStr = readStr()
                    }
                    self.eWrapper.scannerData(tickerId, rank: rank, contractDetails: contract, distance: distance,
                        benchmark: benchmark, projection: projection, legsStr: legsStr)
                }
                self.eWrapper.scannerDataEnd(tickerId)
                
            case .contract_DATA:
                let version = readInt()
                
                var reqId = -1
                if (version >= 3) {
                    reqId = readInt()
                }
                
                let contract = ContractDetails(p_summary: Contract(), p_marketName: "", p_minTick: 0, p_orderTypes: "", p_validExchanges: "", p_underConId: 0, p_longName: "", p_contractMonth: "", p_industry: "", p_category: "", p_subcategory: "", p_timeZoneId: "", p_tradingHours: "", p_liquidHours: "", p_evRule: "", p_evMultiplier: 0)
                contract.summary.symbol = readStr()
                contract.summary.secType = readStr()
                contract.summary.expiry = readStr()
                contract.summary.strike = readDouble()
                contract.summary.right = readStr()
                contract.summary.exchange = readStr()
                contract.summary.currency = readStr()
                contract.summary.localSymbol = readStr()
                contract.marketName = readStr()
                contract.summary.tradingClass = readStr()
                contract.summary.conId = readInt()
                contract.minTick = readDouble()
                contract.summary.multiplier = readStr()
                contract.orderTypes = readStr()
                contract.validExchanges = readStr()
                if (version >= 2) {
                    contract.priceMagnifier = readInt()
                }
                if (version >= 4) {
                    contract.underConId = readInt()
                }
                if( version >= 5) {
                    contract.longName = readStr()
                    contract.summary.primaryExch = readStr()
                }
                if( version >= 6) {
                    contract.contractMonth = readStr()
                    contract.industry = readStr()
                    contract.category = readStr()
                    contract.subcategory = readStr()
                    contract.timeZoneId = readStr()
                    contract.tradingHours = readStr()
                    contract.liquidHours = readStr()
                }
                if (version >= 8) {
                    contract.evRule = readStr()
                    contract.evMultiplier = readDouble()
                }
                if (version >= 7) {
                    let secIdListCount = readInt()
                    if (secIdListCount  > 0) {
                        contract.secIdList = [TagValue]()
                        for _ in 1...secIdListCount {
                            let tagValue = TagValue()
                            tagValue.tag = readStr()
                            tagValue.value = readStr()
                            contract.secIdList?.append(tagValue)
                        }
                    }
                }
                
                self.eWrapper.contractDetails(reqId, contractDetails: contract)
            case .bond_CONTRACT_DATA:
                let version = readInt()
                
                var reqId = -1
                if (version >= 3) {
                    reqId = readInt()
                }
                
                let contract = ContractDetails(p_summary: Contract(), p_marketName: "", p_minTick: 0, p_orderTypes: "", p_validExchanges: "", p_underConId: 0, p_longName: "", p_contractMonth: "", p_industry: "", p_category: "", p_subcategory: "", p_timeZoneId: "", p_tradingHours: "", p_liquidHours: "", p_evRule: "", p_evMultiplier: 0)
                
                contract.summary.symbol = readStr()
                contract.summary.secType = readStr()
                contract.cusip = readStr()
                contract.coupon = readDouble()
                contract.maturity = readStr()
                contract.issueDate  = readStr()
                contract.ratings = readStr()
                contract.bondType = readStr()
                contract.couponType = readStr()
                contract.convertible = readBoolFromInt()
                contract.callable = readBoolFromInt()
                contract.putable = readBoolFromInt()
                contract.descAppend = readStr()
                contract.summary.exchange = readStr()
                contract.summary.currency = readStr()
                contract.marketName = readStr()
                contract.summary.tradingClass = readStr()
                contract.summary.conId = readInt()
                contract.minTick = readDouble()
                contract.orderTypes = readStr()
                contract.validExchanges = readStr()
                if (version >= 2) {
                    contract.nextOptionDate = readStr()
                    contract.nextOptionType = readStr()
                    contract.nextOptionPartial = readBoolFromInt()
                    contract.notes = readStr()
                }
                if( version >= 4) {
                    contract.longName = readStr()
                }
                if (version >= 6) {
                    contract.evRule = readStr()
                    contract.evMultiplier = readDouble()
                }
                if (version >= 5) {
                    let secIdListCount = readInt()
                    if (secIdListCount  > 0) {
                        contract.secIdList = [TagValue]()
                        for _ in 1...secIdListCount {
                            let tagValue = TagValue()
                            tagValue.tag = readStr()
                            tagValue.value = readStr()
                            contract.secIdList?.append(tagValue)
                        }
                    }
                }
                
                self.eWrapper.bondContractDetails(reqId, contractDetails: contract)
            case .execution_DATA:
                let version = readInt()
                
                var reqId = -1
                if (version >= 7) {
                    reqId = readInt()
                }
                
                let orderId = readInt()
                
                // read contract fields
                let contract = Contract()
                if (version >= 5) {
                    contract.conId = readInt()
                }
                contract.symbol = readStr()
                contract.secType = readStr()
                contract.expiry = readStr()
                contract.strike = readDouble()
                contract.right = readStr()
                if (version >= 9) {
                    contract.multiplier = readStr()
                }
                contract.exchange = readStr()
                contract.currency = readStr()
                contract.localSymbol = readStr()
                if (version >= 10) {
                    contract.tradingClass = readStr()
                }
                
                let exec = Execution(p_orderId: 0, p_clientId: 0, p_execId: "", p_time: "", p_acctNumber: "", p_exchange: "", p_side: "", p_shares: 0, p_price: 0, p_permId: 0, p_liquidation: 0, p_cumQty: 0, p_avgPrice: 0, p_orderRef: "", p_evRule: "", p_evMultiplier: 0)
                exec.orderId = orderId
                exec.execId = readStr()
                exec.time = readStr()
                exec.acctNumber = readStr()
                exec.exchange = readStr()
                exec.side = readStr()
                exec.shares = readInt()
                exec.price = readDouble()
                if (version >= 2 ) {
                    exec.permId = readInt()
                }
                if (version >= 3) {
                    exec.clientId = readInt()
                }
                if (version >= 4) {
                    exec.liquidation = readInt()
                }
                if (version >= 6) {
                    exec.cumQty = readInt()
                    exec.avgPrice = readDouble()
                }
                if (version >= 8) {
                    exec.orderRef = readStr()
                }
                if (version >= 9) {
                    exec.evRule = readStr()
                    exec.evMultiplier = readDouble()
                }
                
                self.eWrapper.execDetails( reqId, contract: contract, execution: exec)
            case .market_DEPTH:
                _ = readInt()
                let id = readInt()
                
                let position = readInt()
                let operation = readInt()
                let side = readInt()
                let price = readDouble()
                let size = readInt()
                
                self.eWrapper.updateMktDepth(id, position: position, operation: operation, side: side, price: price, size: size)
            case .market_DEPTH_L2:
                _ = readInt()
                let id = readInt()
                
                let position = readInt()
                let marketMaker = readStr()
                let operation = readInt()
                let side = readInt()
                let price = readDouble()
                let size = readInt()
                
                self.eWrapper.updateMktDepthL2(id, position: position, marketMaker: marketMaker, operation: operation, side: side, price: price, size: size)
            case .news_BULLETINS:
                _ = readInt()
                let newsMsgId = readInt()
                let newsMsgType = readInt()
                let newsMessage = readStr()
                let originatingExch = readStr()
                
                self.eWrapper.updateNewsBulletin( newsMsgId, msgType: newsMsgType, message: newsMessage, origExchange: originatingExch)
            case .managed_ACCTS:
                _ = readInt()
                let accountsList = readStr()
                
                self.eWrapper.managedAccounts( accountsList)
            case .receive_FA:
                _ = readInt()
                let faDataType = readInt()
                let xml = readStr()
                
                self.eWrapper.receiveFA(faDataType, xml: xml)
            case .historical_DATA:
                let version = readInt()
                let reqId = readInt()
                var startDateStr = ""
                var endDateStr = ""
                var completedIndicator = "finished"
                if (version >= 2) {
                    startDateStr = readStr()
                    endDateStr = readStr()
                    completedIndicator += "-\(startDateStr)-\(endDateStr)"
                }
                let itemCount = readInt()
                for _ in 1...itemCount {
                    let date = readStr()
                    let open = readDouble()
                    let high = readDouble()
                    let low = readDouble()
                    let close = readDouble()
                    let volume = readInt()
                    let WAP = readDouble()
                    let hasGaps = caseInsensitiveEqual(readStr(), "true")
                    var barCount = -1
                    if (version >= 3) {
                        barCount = readInt()
                    }
                    self.eWrapper.historicalData(reqId, date: date, open: open, high: high, low: low,
                        close: close, volume: volume, count: barCount, WAP: WAP, hasGaps: hasGaps)
                }
                // send end of dataset marker
                self.eWrapper.historicalData(reqId, date: completedIndicator, open: -1, high: -1, low: -1, close: -1, volume: -1, count: -1, WAP: -1, hasGaps: false)
            case .scanner_PARAMETERS:
                let _ = readInt()
                let xml = readStr()
                self.eWrapper.scannerParameters(xml)
            case .current_TIME:
                let _ = readInt()
                let time = readLong()
                self.eWrapper.currentTime(time)
            case .real_TIME_BARS:
                let _ = readInt()
                let reqId = readInt()
                let time = readLong()
                let open = readDouble()
                let high = readDouble()
                let low = readDouble()
                let close = readDouble()
                let volume = readLong()
                let wap = readDouble()
                let count = readInt()
                self.eWrapper.realtimeBar(reqId, time: time, open: open, high: high, low: low, close: close, volume: volume, wap: wap, count: count)
            case .fundamental_DATA:
                let _ = readInt()
                let reqId = readInt()
                let data = readStr()
                self.eWrapper.fundamentalData(reqId, data: data)
            case .contract_DATA_END:
                let _ = readInt()
                let reqId = readInt()
                self.eWrapper.contractDetailsEnd(reqId)
            case .open_ORDER_END:
                let _ = readInt()
                self.eWrapper.openOrderEnd()
            case .acct_DOWNLOAD_END:
                let _ = readInt()
                let accountName = readStr()
                self.eWrapper.accountDownloadEnd( accountName)
            case .execution_DATA_END:
                let _ = readInt()
                let reqId = readInt()
                self.eWrapper.execDetailsEnd( reqId)
            case .delta_NEUTRAL_VALIDATION:
                let _ = readInt()
                let reqId = readInt()
                
                let underComp = UnderComp()
                underComp.conId = readInt()
                underComp.delta = readDouble()
                underComp.price = readDouble()
                
                self.eWrapper.deltaNeutralValidation(reqId, underComp: underComp)
            case .tick_SNAPSHOT_END:
                let _ = readInt()
                let reqId = readInt()
                
                self.eWrapper.tickSnapshotEnd( reqId)
            case .market_DATA_TYPE:
                let _ = readInt()
                let reqId = readInt()
                let marketDataType = readInt()
                
                self.eWrapper.marketDataType( reqId, marketDataType: marketDataType)
            case .commission_REPORT:
                let _ = readInt()
                
                let commissionReport = CommissionReport()
                commissionReport.execId = readStr()
                commissionReport.commission = readDouble()
                commissionReport.currency = readStr()
                commissionReport.realizedPNL = readDouble()
                commissionReport.yield = readDouble()
                commissionReport.yieldRedemptionDate = readInt()
                
                self.eWrapper.commissionReport(commissionReport)
            case .verify_MESSAGE_API:
                let _ = readInt()
                let apiData = readStr()
                
                self.eWrapper.verifyMessageAPI(apiData)
            case .verify_COMPLETED:
                let _ = readInt()
                let isSuccessfulStr = readStr()
                let isSuccessful = "true" == isSuccessfulStr
                let errorText = readStr()
                
                
                if (isSuccessful) {
                    _parent.startAPI()
                }
                
                self.eWrapper.verifyCompleted(isSuccessful, errorText: errorText)
            case .display_GROUP_LIST:
                let _ = readInt()
                let reqId = readInt()
                let groups = readStr()
                
                self.eWrapper.displayGroupList(reqId, groups: groups)
            case .display_GROUP_UPDATED:
                let _ = readInt()
                let reqId = readInt()
                let contractInfo = readStr()
                
                self.eWrapper.displayGroupUpdated(reqId, contractInfo: contractInfo)
            }
        } else { return false}
        return true
    }
}

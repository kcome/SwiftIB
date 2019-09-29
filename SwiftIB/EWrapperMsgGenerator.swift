//
//  EWrapperMsgGenerator.swift
//  SwiftIB
//
//  Created by Harry Li on 3/01/2015.
//  Copyright (c) 2014-2019 Hanfei Li. All rights reserved.
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

let SCANNER_PARAMETERS = "SCANNER PARAMETERS:"
let FINANCIAL_ADVISOR = "FA:"

open class EWrapperMsgGenerator: AnyWrapperMsgGenerator {
    
    fileprivate class func contractDetailsMsg(_ contractDetails: ContractDetails) -> String {
        return "marketName = " + contractDetails.marketName + "\n" +
            "minTick = " + dtos(contractDetails.minTick) + "\n" +
            "price magnifier = " + itos(contractDetails.priceMagnifier) + "\n" +
            "orderTypes = " + contractDetails.orderTypes + "\n" +
            "validExchanges = " + contractDetails.validExchanges + "\n" +
            "underConId = " + itos(contractDetails.underConId) + "\n" +
            "longName = " + contractDetails.longName + "\n" +
            "contractMonth = " + contractDetails.contractMonth + "\n" +
            "industry = " + contractDetails.industry + "\n" +
            "category = " + contractDetails.category + "\n" +
            "subcategory = " + contractDetails.subcategory + "\n" +
            "timeZoneId = " + contractDetails.timeZoneId + "\n" +
            "tradingHours = " + contractDetails.tradingHours + "\n" +
            "liquidHours = " + contractDetails.liquidHours + "\n" +
            "evRule = " + contractDetails.evRule + "\n" +
            "evMultiplier = " + dtos(contractDetails.evMultiplier) + "\n" +
            EWrapperMsgGenerator.contractDetailsSecIdList(contractDetails)
    }
    
    class func contractDetailsSecIdList(_ contractDetails: ContractDetails) -> String {
        var msg = "secIdList={"
        if let secIdList = contractDetails.secIdList {
            for (i, param) in secIdList.enumerated() {
                if i > 0 {
                    msg += ","
                }
                msg += param.tag + "=" + param.value
            }
        }
        msg += "}\n"
        return msg
    }
    
    class func contractMsg(_ contract: Contract) -> String{
        var msg = "conid = " + itos(contract.conId) + "\n"
        if !contract.symbol.isEmpty {msg += "symbol = " + contract.symbol + "\n"}
        if !contract.secType.isEmpty {msg += "secType = " + contract.secType + "\n"}
        if !contract.expiry.isEmpty {msg += "expiry = " + contract.expiry + "\n"}
        msg += "strike = " + dtos(contract.strike) + "\n"
        if !contract.right.isEmpty {msg += "right = " + contract.right + "\n"}
        if !contract.multiplier.isEmpty {msg += "multiplier = " + contract.multiplier + "\n"}
        if !contract.exchange.isEmpty {msg += "exchange = " + contract.exchange + "\n"}
        if !contract.primaryExch.isEmpty {msg += "primaryExch = " + contract.primaryExch + "\n"}
        if !contract.currency.isEmpty {msg += "currency = " + contract.currency + "\n"}
        if !contract.localSymbol.isEmpty {msg += "localSymbol = " + contract.localSymbol + "\n"}
        if !contract.tradingClass.isEmpty {msg += "tradingClass = " + contract.tradingClass + "\n"}
        return msg
    }
    
    class func scannerDataEnd(_ reqId: Int) -> String {
        return "id = " + itos(reqId) + " =============== end ==============="
    }
    
    class func currentTime(_ time: Int64) -> String {
        let dateFormatter = DateFormatter()
        let orig : TimeInterval = (Double)(time * 1000)
        let str = dateFormatter.string(from: Date(timeIntervalSince1970: orig))
        return "current time = " + ltos(time) + " ( " + str + " ) "
    }
    
    class func fundamentalData(_ reqId: Int, data: String) -> String {
        return String(format:"id = %@ len = %d\n%@", reqId, data.utf16.count, data)
    }
    
    class func deltaNeutralValidation(_ reqId: Int, underComp: UnderComp) -> String {
        return "id = " + itos(reqId)
            + " underComp.conId =" + itos(underComp.conId)
            + " underComp.delta =" + dtos(underComp.delta)
            + " underComp.price =" + dtos(underComp.price)
    }
    class func tickSnapshotEnd(_ tickerId: Int) -> String{
        return "id=" + itos(tickerId) + " =============== end ==============="
    }
    
    class func marketDataType(_ reqId: Int, marketDataType: Int) -> String {
        return "id=" + itos(reqId) + " marketDataType = " + MarketDataType.getField(marketDataType)
    }
    
    class func commissionReport(_ commissionReport: CommissionReport) -> String {
        var cexecId = ""
        var ccurr = ""
        if !commissionReport.execId.isEmpty { cexecId = commissionReport.execId }
        if !commissionReport.currency.isEmpty { ccurr = commissionReport.currency }
        return "commission report:" +
            " execId=" + cexecId +
            " commission=" + dtos(commissionReport.commission) +
            " currency=" + ccurr +
            " realizedPNL=" + dtos(commissionReport.realizedPNL) +
            " yield=" + dtos(commissionReport.yield) +
            " yieldRedemptionDate=" + itos(commissionReport.yieldRedemptionDate)
    }
    
    class func position(_ account: String, contract: Contract, position: Int, avgCost: Double) -> String {
        return " ---- Position begin ----\n" +
            "account = " + account + "\n" +
            EWrapperMsgGenerator.contractMsg(contract) +
            "position = " + itos(position) + "\n" +
            "avgCost = " + dtos(avgCost) + "\n" +
        " ---- Position end ----\n"
    }
    
    class func positionEnd() -> String {
        return " =============== end ==============="
    }
    
    class func accountSummary(_ reqId: Int, account: String, tag: String, value: String, currency: String) -> String {
        return " ---- Account Summary begin ----\n"
            + "reqId = " + itos(reqId) + "\n"
            + "account = " + account + "\n"
            + "tag = " + tag + "\n"
            + "value = " + value + "\n"
            + "currency = " + currency + "\n"
            + " ---- Account Summary end ----\n"
    }
    
    class func accountSummaryEnd(_ reqId: Int) -> String {
        return "id=" + itos(reqId) + " =============== end ==============="
    }
    
    class func tickPrice(_ tickerId: Int, field: Int, price: Double, canAutoExecute: Int) -> String {
        return "id=" + itos(tickerId) + "  " + TickType.getField(field) + "=" + dtos(price) + " " +
            ((canAutoExecute != 0) ? " canAutoExecute" : " noAutoExecute")
    }
    
    class func tickSize(_ tickerId: Int, field: Int, size: Int) -> String {
        return "id=" + itos(tickerId) + "  " + TickType.getField(field) + "=" + itos(size)
    }

    class func tickOptionComputation(_ tickerId: Int, field: Int, impliedVol: Double,
        delta: Double, optPrice: Double, pvDividend: Double,
        gamma: Double, vega: Double, theta: Double, undPrice: Double) -> String {
            var toAdd = "id=" + itos(tickerId) + "  " + TickType.getField(field)
                toAdd += ": vol = " + ((impliedVol >= 0 && impliedVol != Double.nan) ? dtos(impliedVol) : "N/A")
                toAdd += " delta = " + ((abs(delta) <= 1) ? dtos(delta) : "N/A")
                toAdd += " gamma = " + ((abs(gamma) <= 1) ? dtos(gamma) : "N/A")
                toAdd += " vega = " + ((abs(vega) <= 1) ? dtos(vega) : "N/A")
                toAdd += " theta = " + ((abs(theta) <= 1) ? dtos(theta) : "N/A")
                toAdd += " optPrice = " + ((optPrice >= 0 && optPrice != Double.nan) ? dtos(optPrice) : "N/A")
                toAdd += " pvDividend = " + ((pvDividend >= 0 && pvDividend != Double.nan) ? dtos(pvDividend) : "N/A")
                toAdd += " undPrice = " + ((undPrice >= 0 && undPrice != Double.nan) ? dtos(undPrice) : "N/A")
            return toAdd
    }

    class func tickGeneric (_ tickerId: Int, tickType: Int, value: Double) -> String {
        return "id=" + itos(tickerId) + "  " + TickType.getField(tickType) + "=" + dtos(value)
    }
    
    class func tickString (_ tickerId: Int, tickType: Int, value: String) -> String {
        return "id=" + itos(tickerId) + "  " + TickType.getField(tickType) + "=" + value
    }
    
    class func tickEFP (_ tickerId: Int, tickType: Int, basisPoints: Double,
        formattedBasisPoints: String, impliedFuture: Double, holdDays: Int,
        futureExpiry: String, dividendImpact: Double, dividendsToExpiry: Double) -> String {
            return "id=" + itos(tickerId) + "  " + TickType.getField(tickType)
                + ": basisPoints = " + dtos(basisPoints) + "/" + formattedBasisPoints
                + " impliedFuture = " + dtos(impliedFuture) + " holdDays = " + itos(holdDays) +
                " futureExpiry = " + futureExpiry + " dividendImpact = " + dtos(dividendImpact) +
                " dividends to expiry = "   + dtos(dividendsToExpiry)
    }
    
    class func orderStatus(_ orderId: Int, status: String, filled: Int, remaining: Int,
        avgFillPrice: Double, permId: Int, parentId: Int, lastFillPrice: Double,
        clientId: Int, whyHeld: String) -> String {
            return "order status: orderId=" + itos(orderId) + " clientId=" + itos(clientId) + " permId=" + itos(permId) +
                " status=" + status + " filled=" + itos(filled) + " remaining=" + itos(remaining) +
                " avgFillPrice=" + dtos(avgFillPrice) + " lastFillPrice=" + dtos(lastFillPrice) +
                " parent Id=" + itos(parentId) + " whyHeld=" + whyHeld
    }
    
    class func openOrder(_ orderId: Int, contract: Contract, order: Order, orderState: OrderState) -> String {
        var msg = "open order: orderId=\(orderId)"
        msg += " action=\(order.action)"
        msg += " quantity=\(order.totalQuantity)"
        msg += " conid=\(contract.conId)"
        msg += " symbol=\(contract.symbol)"
        msg += " secType=\(contract.secType)"
        msg += " expiry=\(contract.expiry)"
        msg += " strike=\(contract.strike)"
        msg += " right=\(contract.right)"
        msg += " multiplier=\(contract.multiplier)"
        msg += " exchange=\(contract.exchange)"
        msg += " primaryExch=\(contract.primaryExch)"
        msg += " currency=\(contract.currency)"
        msg += " localSymbol=\(contract.localSymbol)"
        msg += " tradingClass=\(contract.tradingClass)"
        msg += " type=\(order.orderType)"
        msg += " lmtPrice=\(order.lmtPrice)"
        msg += " auxPrice=\(order.auxPrice)"
        msg += " TIF=\(order.tif)"
        msg += " localSymbol=\(contract.localSymbol)"
        msg += " client Id=\(order.clientId)"
        msg += " parent Id=\(order.parentId)"
        msg += " permId=\(order.permId)"
        msg += " outsideRth=\(order.outsideRth)"
        msg += " hidden=\(order.hidden)"
        msg += " discretionaryAmt=\(order.discretionaryAmt)"
        msg += " displaySize=\(order.displaySize)"
        msg += " triggerMethod=\(order.triggerMethod)"
        msg += " goodAfterTime=\(order.goodAfterTime)"
        msg += " goodTillDate=\(order.goodTillDate)"
        msg += " faGroup=\(order.faGroup)"
        msg += " faMethod=\(order.faMethod)"
        msg += " faPercentage=\(order.faPercentage)"
        msg += " faProfile=\(order.faProfile)"
        msg += " shortSaleSlot=\(order.shortSaleSlot)"
        msg += " designatedLocation=\(order.designatedLocation)"
        msg += " exemptCode=\(order.exemptCode)"
        msg += " ocaGroup=\(order.ocaGroup)"
        msg += " ocaType=\(order.ocaType)"
        msg += " rule80A=\(order.rule80A)"
        msg += " allOrNone=\(order.allOrNone)"
        msg += " minQty=\(order.minQty)"
        msg += " percentOffset=\(order.percentOffset)"
        msg += " eTradeOnly=\(order.eTradeOnly)"
        msg += " firmQuoteOnly=\(order.firmQuoteOnly)"
        msg += " nbboPriceCap=\(order.nbboPriceCap)"
        msg += " optOutSmartRouting=\(order.optOutSmartRouting)"
        msg += " auctionStrategy=\(order.auctionStrategy)"
        msg += " startingPrice=\(order.startingPrice)"
        msg += " stockRefPrice=\(order.stockRefPrice)"
        msg += " delta=\(order.delta)"
        msg += " stockRangeLower=\(order.stockRangeLower)"
        msg += " stockRangeUpper=\(order.stockRangeUpper)"
        msg += " volatility=\(order.volatility)"
        msg += " volatilityType=\(order.volatilityType)"
        msg += " deltaNeutralOrderType=\(order.deltaNeutralOrderType)"
        msg += " deltaNeutralAuxPrice=\(order.deltaNeutralAuxPrice)"
        msg += " deltaNeutralConId=\(order.deltaNeutralConId)"
        msg += " deltaNeutralSettlingFirm=\(order.deltaNeutralSettlingFirm)"
        msg += " deltaNeutralClearingAccount=\(order.deltaNeutralClearingAccount)"
        msg += " deltaNeutralClearingIntent=\(order.deltaNeutralClearingIntent)"
        msg += " deltaNeutralOpenClose=\(order.deltaNeutralOpenClose)"
        msg += " deltaNeutralShortSale=\(order.deltaNeutralShortSale)"
        msg += " deltaNeutralShortSaleSlot=\(order.deltaNeutralShortSaleSlot)"
        msg += " deltaNeutralDesignatedLocation=\(order.deltaNeutralDesignatedLocation)"
        msg += " continuousUpdate=\(order.continuousUpdate)"
        msg += " referencePriceType=\(order.referencePriceType)"
        msg += " trailStopPrice=\(order.trailStopPrice)"
        msg += " trailingPercent=\(order.trailingPercent)"
        msg += " scaleInitLevelSize=\(order.scaleInitLevelSize)"
        msg += " scaleSubsLevelSize=\(order.scaleSubsLevelSize)"
        msg += " scalePriceIncrement=\(order.scalePriceIncrement)"
        msg += " scalePriceAdjustValue=\(order.scalePriceAdjustValue)"
        msg += " scalePriceAdjustInterval=\(order.scalePriceAdjustInterval)"
        msg += " scaleProfitOffset=\(order.scaleProfitOffset)"
        msg += " scaleAutoReset=\(order.scaleAutoReset)"
        msg += " scaleInitPosition=\(order.scaleInitPosition)"
        msg += " scaleInitFillQty=\(order.scaleInitFillQty)"
        msg += " scaleRandomPercent=\(order.scaleRandomPercent)"
        msg += " hedgeType=\(order.hedgeType)"
        msg += " hedgeParam=\(order.hedgeParam)"
        msg += " account=\(order.account)"
        msg += " settlingFirm=\(order.settlingFirm)"
        msg += " clearingAccount=\(order.clearingAccount)"
        msg += " clearingIntent=\(order.clearingIntent)"
        msg += " notHeld=\(order.notHeld)"
        msg += " whatIf=\(order.whatIf)"

        if ("BAG" == contract.secType) {
            if !contract.comboLegsDescrip.isEmpty {
                msg += " comboLegsDescrip=" + contract.comboLegsDescrip
            }
        
            msg += " comboLegs={"
            if contract.comboLegs.count > 0 {
                var counter = 0
                for comboLeg in contract.comboLegs {
                    msg += " leg \(counter+1): "
                    msg += " conId= \(comboLeg.conId)"
                    msg += " ratio= \(comboLeg.ratio)"
                    msg += " action= \(comboLeg.action)"
                    msg += " exchange= \(comboLeg.exchange)"
                    msg += " openClose= \(comboLeg.openClose)"
                    msg += " shortSaleSlot= \(comboLeg.shortSaleSlot)"
                    msg += " designatedLocation= \(comboLeg.designatedLocation)"
                    msg += " exemptCode= \(comboLeg.exemptCode)"
                    if contract.comboLegs.count == order.orderComboLegs.count {
                        let orderComboLeg = order.orderComboLegs[counter]
                        msg += " price=\(orderComboLeg.price)"
                    }
                    msg += ";"
                    counter += 1
                }
            }
            msg += "}"
            
            if order.basisPoints != Double.nan {
                msg += " basisPoints=\(order.basisPoints)"
                msg += " basisPointsType=\(order.basisPointsType)"
            }
        }
        
        if let underComp = contract.underComp {
            msg +=
                " underComp.conId =\(underComp.conId)" +
                " underComp.delta =\(underComp.delta)" +
                " underComp.price =\(underComp.price)"
        }
        
        if !order.algoStrategy.isEmpty {
            msg += " algoStrategy=\(order.algoStrategy)"
            msg += " algoParams={"
            if order.algoParams.count > 0 {
                var counter = 0
                for param in order.algoParams {
                    if counter > 0 {
                        msg += ","
                    }
                    msg += param.tag + "=" + param.value
                    counter += 1
                }
            }
            msg += "}"
        }
        
        if ("BAG" == contract.secType) {
            msg += " smartComboRoutingParams={"
            if order.smartComboRoutingParams.count > 0 {
                var counter = 0
                for param in order.smartComboRoutingParams {
                    if counter > 0 {
                        msg += ","
                    }
                    msg += param.tag + "=" + param.value
                    counter += 1
                }
            }
            msg += "}"
        }
        
        let orderStateMsg =
        " status=" + orderState.status
        + " initMargin=" + orderState.initMargin
        + " maintMargin=" + orderState.maintMargin
        + " equityWithLoan=" + orderState.equityWithLoan
        + " commission=" + dtos(orderState.commission)
        + " minCommission=" + dtos(orderState.minCommission)
        + " maxCommission=" + dtos(orderState.maxCommission)
        + " commissionCurrency=" + orderState.commissionCurrency
        + " warningText=" + orderState.warningText
        
        return msg + orderStateMsg
    }

    class func openOrderEnd() ->  String{
        return " =============== end ==============="
    }
    
    class func updateAccountValue(_ key: String, value: String, currency: String, accountName: String) -> String {
        return "updateAccountValue: \(key) \(value) \(currency) \(accountName)"
    }
    
    class func updatePortfolio(_ contract: Contract, position: Int, marketPrice: Double,
        marketValue: Double, averageCost: Double, unrealizedPNL: Double,
        realizedPNL: Double, accountName: String) -> String {
            return "updatePortfolio: \(contractMsg(contract)) \(position) \(marketPrice) \(marketValue) \(averageCost) \(unrealizedPNL) \(realizedPNL) \(accountName)"
    }
    
    class func updateAccountTime(_ timeStamp: String) -> String {
        return "updateAccountTime: " + timeStamp
    }
    
    class func accountDownloadEnd(_ accountName: String) -> String {
        return "accountDownloadEnd: " + accountName
    }
    
    class func nextValidId(_ orderId: Int) -> String {
        return "Next Valid Order ID: \(orderId)"
    }
    
    class func contractDetails(_ reqId: Int, contractDetails: ContractDetails) -> String {
        let contract = contractDetails.summary
        return "reqId = \(reqId) ===================================\n"
            + " ---- Contract Details begin ----\n"
            + "\(contractMsg(contract)) \(contractDetailsMsg(contractDetails))\n"
            + " ---- Contract Details End ----\n"
    }
    
    class func bondContractDetails(_ reqId: Int, contractDetails: ContractDetails) -> String {
        let contract = contractDetails.summary
        var msg = "reqId = \(reqId) ==================================\n"
        msg += " ---- Bond Contract Details begin ----\n"
        msg += "symbol = \(contract.symbol)\n"
        msg += "secType = \(contract.secType)\n"
        msg += "cusip = \(contractDetails.cusip)\n"
        msg += "coupon = \(contractDetails.coupon)\n"
        msg += "maturity = \(contractDetails.maturity)\n"
        msg += "issueDate = \(contractDetails.issueDate)\n"
        msg += "ratings = \(contractDetails.ratings)\n"
        msg += "bondType = \(contractDetails.bondType)\n"
        msg += "couponType = \(contractDetails.couponType)\n"
        msg += "convertible = \(contractDetails.convertible)\n"
        msg += "callable = \(contractDetails.callable)\n"
        msg += "putable = \(contractDetails.putable)\n"
        msg += "descAppend = \(contractDetails.descAppend)\n"
        msg += "exchange = \(contract.exchange)\n"
        msg += "currency = \(contract.currency)\n"
        msg += "marketName = \(contractDetails.marketName)\n"
        msg += "tradingClass = \(contract.tradingClass)\n"
        msg += "conid = \(contract.conId)\n"
        msg += "minTick = \(contractDetails.minTick)\n"
        msg += "orderTypes = \(contractDetails.orderTypes)\n"
        msg += "validExchanges = \(contractDetails.validExchanges)\n"
        msg += "nextOptionDate = \(contractDetails.nextOptionDate)\n"
        msg += "nextOptionType = \(contractDetails.nextOptionType)\n"
        msg += "nextOptionPartial = \(contractDetails.nextOptionPartial)\n"
        msg += "notes = \(contractDetails.notes)\n"
        msg += "longName = \(contractDetails.longName)\n"
        msg += "evRule = \(contractDetails.evRule)\n"
        msg += "evMultiplier = \(contractDetails.evMultiplier)\n"
        msg += "\(contractDetailsSecIdList(contractDetails))"
        msg += " ---- Bond Contract Details End ----\n"
        return msg
    }

    class func contractDetailsEnd(_ reqId: Int) -> String {
        return "reqId = \(reqId) =============== end ==============="
    }
    
    class func execDetails(_ reqId: Int, contract: Contract, execution: Execution) -> String {
        var msg = " ---- Execution Details begin ----\n"
        msg += "reqId = \(reqId)\n"
        msg += "orderId = \(execution.orderId)\n"
        msg += "clientId = \(execution.clientId)\n"
        msg += contractMsg(contract)
        msg += "execId = \(execution.execId)\n"
        msg += "time = \(execution.time)\n"
        msg += "acctNumber = \(execution.acctNumber)\n"
        msg += "executionExchange = \(execution.exchange)\n"
        msg += "side = \(execution.side)\n"
        msg += "shares = \(execution.shares)\n"
        msg += "price = \(execution.price)\n"
        msg += "permId = \(execution.permId)\n"
        msg += "liquidation = \(execution.liquidation)\n"
        msg += "cumQty = \(execution.cumQty)\n"
        msg += "avgPrice = \(execution.avgPrice)\n"
        msg += "orderRef = \(execution.orderRef)\n"
        msg += "evRule = \(execution.evRule)\n"
        msg += "evMultiplier = \(execution.evMultiplier)\n"
        msg += " ---- Execution Details end ----\n"
        return msg
    }
    
    class func execDetailsEnd(_ reqId: Int) -> String {
        return "reqId = \(reqId) =============== end ==============="
    }

    class func updateMktDepth(_ tickerId: Int, position: Int, operation: Int, side: Int,
        price: Double, size: Int) -> String {
            return "updateMktDepth: \(tickerId) \(position) \(operation) \(side) \(price) \(size)"
    }
    
    class func updateMktDepthL2(_ tickerId: Int, position: Int, marketMaker: String,
        operation: Int, side: Int, price: Double, size: Int) -> String {
            return "updateMktDepth: \(tickerId) \(position) \(marketMaker) \(operation) \(side) \(price) \(size)"
    }
    
    class func updateNewsBulletin(_ msgId: Int, msgType: Int, message: String, origExchange: String) -> String {
        return "MsgId=\(msgId) :: MsgType=\(msgType) :: Origin=\(origExchange) :: Message=\(message)"
    }
    
    class func managedAccounts(_ accountsList: String ) -> String {
        return "Connected : The list of managed accounts are : [" + accountsList + "]"
    }
    
    class func receiveFA(_ faDataType: Int, xml: String) -> String {
        return "\(FINANCIAL_ADVISOR) \(EClientSocket.faMsgTypeName(faDataType)) \(xml)"
    }
    
    class func historicalData(_ reqId: Int, date: String, open: Double, high: Double, low: Double,
        close: Double, volume: Int, count: Int, WAP: Double, hasGaps: Bool) -> String {
            return "id=\(reqId) date = \(date) open=\(open) high=\(high) low=\(low) close=\(close) volume=\(volume) count=\(count) WAP=\(WAP) hasGaps=\(hasGaps)"
    }

    class func realtimeBar(_ reqId: Int, time: Int64, open: Double,
        high: Double, low: Double, close: Double, volume: Int64, wap: Double, count: Int) -> String {
            return "id=\(reqId) time = \(time) open=\(open) high=\(high) low=\(low) close=\(close) volume=\(volume) count=\(count) WAP=\(wap)"
    }
    
    class func scannerParameters(_ xml: String) -> String {
        return SCANNER_PARAMETERS + "\n" + xml
    }
    
    class func scannerData(_ reqId: Int, rank: Int, contractDetails: ContractDetails,
        distance: String, benchmark: String, projection: String, legsStr: String) -> String {
            let contract = contractDetails.summary
            return "id = \(reqId) rank=\(rank) symbol=\(contract.symbol) secType=\(contract.secType) expiry=\(contract.expiry) strike=\(contract.strike) right=\(contract.right) exchange=\(contract.exchange) currency=\(contract.currency) localSymbol=\(contract.localSymbol) marketName=\(contractDetails.marketName) tradingClass=\(contract.tradingClass) distance=\(distance) benchmark=\(benchmark) projection=\(projection) legsStr=\(legsStr)"
    }
}

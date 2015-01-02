//
//  EWrapper.swift
//  SwiftIB
//
//  Created by Harry Li on 3/01/2015.
//  Copyright (c) 2015 Hanfei Li. All rights reserved.
//

import Foundation

protocol EWrapper: AnyWrapper {
    
    ///////////////////////////////////////////////////////////////////////
    // Interface methods
    ///////////////////////////////////////////////////////////////////////
    func tickPrice(tickerId: Int, field: Int, price: Double, canAutoExecute: Int)
    func tickSize(tickerId: Int, field: Int, size: Int)
    func tickOptionComputation(tickerId: Int, field: Int, impliedVol: Double,
        delta: Double, optPrice: Double, pvDividend: Double,
        gamma: Double, vega: Double, theta: Double, undPrice: Double)
    func tickGeneric(tickerId: Int, tickType: Int, value: Double)
    func tickString(tickerId: Int, tickType: Int, value: String)
    func tickEFP(tickerId: Int, tickType: Int, basisPoints: Double,
        formattedBasisPoints: String, impliedFuture: Double, holdDays: Int,
        futureExpiry: String, dividendImpact: Double, dividendsToExpiry: Double)
    func orderStatus(orderId: Int, status: String, filled: Int, remaining: Int,
        avgFillPrice: Double, permId: Int, parentId: Int, lastFillPrice: Double,
        clientId: Int, whyHeld: String)
    func openOrder(orderId: Int, contract: Contract, order: Order, orderState: OrderState)
    func openOrderEnd()
    func updateAccountValue(key: String, value: String, currency: String, accountName: String)
    func updatePortfolio(contract: Contract, position: Int, marketPrice: Double, marketValue: Double,
        averageCost: Double, unrealizedPNL: Double, realizedPNL: Double, accountName: String)
    func updateAccountTime(timeStamp: String)
    func accountDownloadEnd(accountName: String)
    func nextValidId(orderId: Int)
    func contractDetails(reqId: Int, contractDetails: ContractDetails)
    func bondContractDetails(reqId: Int, contractDetails: ContractDetails)
    func contractDetailsEnd(reqId: Int)
    func execDetails(reqId: Int, contract: Contract, execution: Execution)
    func execDetailsEnd(reqId: Int)
    func updateMktDepth(tickerId: Int, position: Int, operation: Int, side: Int, price: Double, size: Int)
    func updateMktDepthL2(tickerId: Int, position: Int, marketMaker: String, operation: Int,
        side: Int, price: Double, size: Int)
    func updateNewsBulletin(msgId: Int, msgType: Int, message: String, origExchange: String)
    func managedAccounts(accountsList: String)
    func receiveFA(faDataType: Int, xml: String)
    func historicalData(reqId: Int, date: String, open: Double, high: Double, low: Double,
        close: Double, volume: Int, count: Int, WAP: Double, hasGaps: Bool)
    func scannerParameters(xml: String)
    func scannerData(reqId: Int, rank: Int, contractDetails: ContractDetails, distance: String,
        benchmark: String, projection: String, legsStr: String)
    func scannerDataEnd(reqId: Int)
    func realtimeBar(reqId: Int, time: Int64, open: Double, high: Double, low: Double, close: Double, volume: Int64, wap: Double, count: Int)
    func currentTime(time: Int64)
    func fundamentalData(reqId: Int, data: String)
    func deltaNeutralValidation(reqId: Int, underComp: UnderComp)
    func tickSnapshotEnd(reqId: Int)
    func marketDataType(reqId: Int, marketDataType: Int)
    func commissionReport(commissionReport: CommissionReport)
    func position(account: String, contract: Contract, pos: Int, avgCost: Double)
    func positionEnd()
    func accountSummary(reqId: Int, account: String, tag: String, value: String, currency: String)
    func accountSummaryEnd(reqId: Int)
    func verifyMessageAPI(apiData: String)
    func verifyCompleted(isSuccessful: Bool, errorText: String)
    func displayGroupList(reqId: Int, groups: String)
    func displayGroupUpdated(reqId: Int, contractInfo: String)
}

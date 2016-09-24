//
//  EWrapper.swift
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

public protocol EWrapper: AnyWrapper {
    
    ///////////////////////////////////////////////////////////////////////
    // Interface methods
    ///////////////////////////////////////////////////////////////////////
    func tickPrice(_ tickerId: Int, field: Int, price: Double, canAutoExecute: Int)
    func tickSize(_ tickerId: Int, field: Int, size: Int)
    func tickOptionComputation(_ tickerId: Int, field: Int, impliedVol: Double,
        delta: Double, optPrice: Double, pvDividend: Double,
        gamma: Double, vega: Double, theta: Double, undPrice: Double)
    func tickGeneric(_ tickerId: Int, tickType: Int, value: Double)
    func tickString(_ tickerId: Int, tickType: Int, value: String)
    func tickEFP(_ tickerId: Int, tickType: Int, basisPoints: Double,
        formattedBasisPoints: String, impliedFuture: Double, holdDays: Int,
        futureExpiry: String, dividendImpact: Double, dividendsToExpiry: Double)
    func orderStatus(_ orderId: Int, status: String, filled: Int, remaining: Int,
        avgFillPrice: Double, permId: Int, parentId: Int, lastFillPrice: Double,
        clientId: Int, whyHeld: String)
    func openOrder(_ orderId: Int, contract: Contract, order: Order, orderState: OrderState)
    func openOrderEnd()
    func updateAccountValue(_ key: String, value: String, currency: String, accountName: String)
    func updatePortfolio(_ contract: Contract, position: Int, marketPrice: Double, marketValue: Double,
        averageCost: Double, unrealizedPNL: Double, realizedPNL: Double, accountName: String)
    func updateAccountTime(_ timeStamp: String)
    func accountDownloadEnd(_ accountName: String)
    func nextValidId(_ orderId: Int)
    func contractDetails(_ reqId: Int, contractDetails: ContractDetails)
    func bondContractDetails(_ reqId: Int, contractDetails: ContractDetails)
    func contractDetailsEnd(_ reqId: Int)
    func execDetails(_ reqId: Int, contract: Contract, execution: Execution)
    func execDetailsEnd(_ reqId: Int)
    func updateMktDepth(_ tickerId: Int, position: Int, operation: Int, side: Int, price: Double, size: Int)
    func updateMktDepthL2(_ tickerId: Int, position: Int, marketMaker: String, operation: Int,
        side: Int, price: Double, size: Int)
    func updateNewsBulletin(_ msgId: Int, msgType: Int, message: String, origExchange: String)
    func managedAccounts(_ accountsList: String)
    func receiveFA(_ faDataType: Int, xml: String)
    func historicalData(_ reqId: Int, date: String, open: Double, high: Double, low: Double,
        close: Double, volume: Int, count: Int, WAP: Double, hasGaps: Bool)
    func scannerParameters(_ xml: String)
    func scannerData(_ reqId: Int, rank: Int, contractDetails: ContractDetails, distance: String,
        benchmark: String, projection: String, legsStr: String)
    func scannerDataEnd(_ reqId: Int)
    func realtimeBar(_ reqId: Int, time: Int64, open: Double, high: Double, low: Double, close: Double, volume: Int64, wap: Double, count: Int)
    func currentTime(_ time: Int64)
    func fundamentalData(_ reqId: Int, data: String)
    func deltaNeutralValidation(_ reqId: Int, underComp: UnderComp)
    func tickSnapshotEnd(_ reqId: Int)
    func marketDataType(_ reqId: Int, marketDataType: Int)
    func commissionReport(_ commissionReport: CommissionReport)
    func position(_ account: String, contract: Contract, pos: Int, avgCost: Double)
    func positionEnd()
    func accountSummary(_ reqId: Int, account: String, tag: String, value: String, currency: String)
    func accountSummaryEnd(_ reqId: Int)
    func verifyMessageAPI(_ apiData: String)
    func verifyCompleted(_ isSuccessful: Bool, errorText: String)
    func displayGroupList(_ reqId: Int, groups: String)
    func displayGroupUpdated(_ reqId: Int, contractInfo: String)
}

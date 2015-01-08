//
//  main.swift
//  SwiftIB
//
//  Created by Hanfei Li on 31/12/2014.
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
import CoreServices
import Cocoa

class LoggingWrapper: EWrapper {
    var tickers: [String]
    init(_ ts: [String]) {
        tickers = ts
    }
    
    func tickPrice(tickerId: Int, field: Int, price: Double, canAutoExecute: Int) {
        println("PRC \(tickers[tickerId]) \(field) \(price)")
    }
    func tickSize(tickerId: Int, field: Int, size: Int) {
        println("SZ  \(tickers[tickerId]) \(field) \(size)")
    }
    func tickGeneric(tickerId: Int, tickType: Int, value: Double) {
        println("GEN \(tickers[tickerId]) \(tickType) \(value)")
    }
    func tickString(tickerId: Int, tickType: Int, value: String) {
        switch tickType {
        case 45:
            let tickI: Int? = value.toInt()
            let tick: Double = tickI != nil ? Double(tickI!) : 0
            let fmt = NSDateFormatter()
            fmt.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS zzz"
            let ts = fmt.stringFromDate(NSDate(timeIntervalSince1970: NSTimeInterval(tick)))
            println("STR TS \(tickers[tickerId]) \(ts)")
            
            default:
            println("STR \(tickers[tickerId]) \(tickType) \(value)")
        }
    }
    func accountDownloadEnd(accountName: String){
        println("Account name \(accountName)")
    }

    // currently unused callbacks
    func tickOptionComputation(tickerId: Int, field: Int, impliedVol: Double, delta: Double, optPrice: Double, pvDividend: Double, gamma: Double, vega: Double, theta: Double, undPrice: Double) {}
    func tickEFP(tickerId: Int, tickType: Int, basisPoints: Double,
        formattedBasisPoints: String, impliedFuture: Double, holdDays: Int,
        futureExpiry: String, dividendImpact: Double, dividendsToExpiry: Double){}
    func orderStatus(orderId: Int, status: String, filled: Int, remaining: Int,
        avgFillPrice: Double, permId: Int, parentId: Int, lastFillPrice: Double,
        clientId: Int, whyHeld: String){}
    func openOrder(orderId: Int, contract: Contract, order: Order, orderState: OrderState){}
    func openOrderEnd(){}
    func updateAccountValue(key: String, value: String, currency: String, accountName: String){}
    func updatePortfolio(contract: Contract, position: Int, marketPrice: Double, marketValue: Double,
        averageCost: Double, unrealizedPNL: Double, realizedPNL: Double, accountName: String){}
    func updateAccountTime(timeStamp: String){}
    func nextValidId(orderId: Int){}
    func contractDetails(reqId: Int, contractDetails: ContractDetails){}
    func bondContractDetails(reqId: Int, contractDetails: ContractDetails){}
    func contractDetailsEnd(reqId: Int){}
    func execDetails(reqId: Int, contract: Contract, execution: Execution){}
    func execDetailsEnd(reqId: Int){}
    func updateMktDepth(tickerId: Int, position: Int, operation: Int, side: Int, price: Double, size: Int){}
    func updateMktDepthL2(tickerId: Int, position: Int, marketMaker: String, operation: Int,
        side: Int, price: Double, size: Int){}
    func updateNewsBulletin(msgId: Int, msgType: Int, message: String, origExchange: String){}
    func managedAccounts(accountsList: String){}
    func receiveFA(faDataType: Int, xml: String){}
    func historicalData(reqId: Int, date: String, open: Double, high: Double, low: Double,
        close: Double, volume: Int, count: Int, WAP: Double, hasGaps: Bool){}
    func scannerParameters(xml: String){}
    func scannerData(reqId: Int, rank: Int, contractDetails: ContractDetails, distance: String,
        benchmark: String, projection: String, legsStr: String){}
    func scannerDataEnd(reqId: Int){}
    func realtimeBar(reqId: Int, time: Int64, open: Double, high: Double, low: Double, close: Double, volume: Int64, wap: Double, count: Int) {}
    func currentTime(time: Int64){}
    func fundamentalData(reqId: Int, data: String){}
    func deltaNeutralValidation(reqId: Int, underComp: UnderComp){}
    func tickSnapshotEnd(reqId: Int){}
    func marketDataType(reqId: Int, marketDataType: Int){}
    func commissionReport(commissionReport: CommissionReport){}
    func position(account: String, contract: Contract, pos: Int, avgCost: Double){}
    func positionEnd(){}
    func accountSummary(reqId: Int, account: String, tag: String, value: String, currency: String){}
    func accountSummaryEnd(reqId: Int){}
    func verifyMessageAPI(apiData: String){}
    func verifyCompleted(isSuccessful: Bool, errorText: String){}
    func displayGroupList(reqId: Int, groups: String){}
    func displayGroupUpdated(reqId: Int, contractInfo: String){}

    // error handling
    func error( e: NSException) {}
    func error( str: String) {
        println("error: \(str)")
    }
    func error( id: Int, errorCode: Int, errorMsg:String) {
        println("error: id(\(id)) code(\(errorCode)) msg:\(errorMsg)")
    }
    func connectionClosed() {
        println ("!!CONNECTION CLOSE")
        disconnected = true
    }
}

var disconnected = false

println("connecting to IB API...")
var tickers:[String] = []
for arg in Process.arguments[1..<Process.arguments.count] {
    tickers.append(arg)
}
var wrapper = LoggingWrapper(tickers)
var client = EClientSocket(p_eWrapper: wrapper, p_anyWrapper: wrapper)
while true {
    client.eConnect("127.0.0.1", p_port: 7496)
    disconnected = false
    for i in 0...2 {
        var con = Contract(p_conId: 0, p_symbol: tickers[i], p_secType: "STK", p_expiry: "", p_strike: 0.0, p_right: "", p_multiplier: "",
            p_exchange: "SMART", p_currency: "USD", p_localSymbol: tickers[i], p_tradingClass: "", p_comboLegs: [ComboLeg](), p_primaryExch: "ISLAND",
            p_includeExpired: true, p_secIdType: "", p_secId: "")
        client.reqMktData(i, contract: con, genericTickList: "", snapshot: false, mktDataOptions: nil)
    }
    while !disconnected { NSThread.sleepForTimeInterval(NSTimeInterval(2.0)) }
    client.eDisconnect()
    client.close()
}

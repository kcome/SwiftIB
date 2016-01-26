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

import SwiftIB

var outputFiles:[NSFileHandle] = []

class LoggingWrapper: EWrapper {
    init() {
    }
    
    func tickPrice(tickerId: Int, field: Int, price: Double, canAutoExecute: Int) {
        let f = outputFiles[tickerId]
        let s = "PRC \(field) \(price)\n"
        f.writeData(s.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!);f.synchronizeFile()
    }
    func tickSize(tickerId: Int, field: Int, size: Int) {
        let f = outputFiles[tickerId]
        let s = "SZ  \(field) \(size)\n"
        f.writeData(s.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!);f.synchronizeFile()
    }
    func tickGeneric(tickerId: Int, tickType: Int, value: Double) {
        let f = outputFiles[tickerId]
        let s = "GEN \(tickType) \(value)\n"
        f.writeData(s.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!);f.synchronizeFile()
    }
    func tickString(tickerId: Int, tickType: Int, value: String) {
        let f = outputFiles[tickerId]
        var s = ""
        switch tickType {
        case 45:
            let tickI: Int? = value.toInt()
            let tick: Double = tickI != nil ? Double(tickI!) : 0
            s = "STR TS \(LoggingWrapper.timeToStr(NSDate(timeIntervalSince1970: NSTimeInterval(tick)), millis:true))\n"
            
            default:
            s = "STR \(tickType) \(value)\n"
        }
        f.writeData(s.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!);f.synchronizeFile()
    }
    func accountDownloadEnd(accountName: String){
        print("Account name \(accountName)")
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
        print("error: \(str)")
    }
    func error( id: Int, errorCode: Int, errorMsg:String) {
        print("error: id(\(id)) code(\(errorCode)) msg:\(errorMsg)")
    }
    func connectionClosed() {
        println ("!!CONNECTION CLOSE")
        connected = false
    }

    class func timeToStr(time: NSDate, millis: Bool) -> String {
        let fmt = NSDateFormatter()
        fmt.dateFormat = millis ? "yyyy-MM-dd HH:mm:ss.SSS zzz" : "yyyy-MM-dd HH:mm:ss zzz"
        return fmt.stringFromDate(time)
    }
}

var connected = false
var host = "127.0.0.1"
var port: UInt32 = 7496
var tickers:[String] = []
var outputDir: String = NSFileManager.defaultManager().currentDirectoryPath
let filePrefix = LoggingWrapper.timeToStr(NSDate(timeIntervalSinceNow: 0), millis:false)

var argValue:[Bool] = [Bool](count: Process.arguments.count, repeatedValue: false)
var index = 1
for arg in Process.arguments[1..<Process.arguments.count] {
    switch arg {
    case "--host":
        if index+1<Process.arguments.count {host = Process.arguments[index+1]}
        argValue[index+1] = true
    case "--output":
        if index+1<Process.arguments.count {outputDir = Process.arguments[index+1]}
        argValue[index+1] = true
    case "--port":
        if index+1<Process.arguments.count {
            if let p = Process.arguments[index+1].toInt() {
                port = UInt32(p)
            }
        }
        argValue[index+1] = true
    default:
        if argValue[index] == false {
            tickers.append(arg)
        }
    }
    index += 1
}

print("Output dir: \(outputDir)")
print("Symbols to fetch: \(tickers)")

for i in 0 ..< tickers.count {
    var outf = outputDir.stringByAppendingPathComponent(String(format: "%@ %@.raw.dump", filePrefix, tickers[i]))
    var file = NSFileHandle(forWritingAtPath:outf)
    if file == nil {
        NSFileManager.defaultManager().createFileAtPath(outf, contents: nil, attributes: nil)
        file = NSFileHandle(forWritingAtPath:outf)
    }
    if file != nil {
        outputFiles.append(file!)
        let s = "SYMBOL \(tickers[i]) \n"
        file!.writeData(s.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
        file!.synchronizeFile()
    }
}
if outputFiles.count != tickers.count {
    print("Error: cannot correct output files")
    NSApplication.sharedApplication().terminate(nil)
}

while true {
    var wrapper = LoggingWrapper()
    var client = EClientSocket(p_eWrapper: wrapper, p_anyWrapper: wrapper)
    print("Connecting to IB API...")
    client.eConnect(host, p_port: port)
    connected = true
    for i in 0 ..< tickers.count {
        var con = Contract(p_conId: 0, p_symbol: tickers[i], p_secType: "STK", p_expiry: "", p_strike: 0.0, p_right: "", p_multiplier: "",
            p_exchange: "SMART", p_currency: "USD", p_localSymbol: tickers[i], p_tradingClass: "", p_comboLegs: nil, p_primaryExch: "ISLAND",
            p_includeExpired: true, p_secIdType: "", p_secId: "")
        // tickerId is strickly 0..<tickers.count
        client.reqMktData(i, contract: con, genericTickList: "", snapshot: false, mktDataOptions: nil)
    }
    while connected { NSThread.sleepForTimeInterval(NSTimeInterval(3.0)) }
    client.eDisconnect()
    client.close()
}

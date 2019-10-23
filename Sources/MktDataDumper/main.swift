//
//  main.swift
//  SwiftIB
//
//  Created by Hanfei Li on 31/12/2014.
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

import SwiftIB

var outputFiles:[FileHandle] = []

class LoggingWrapper: EWrapper {
    init() {
    }
    
    func tickPrice(_ tickerId: Int, field: Int, price: Double, canAutoExecute: Int) {
        let f = outputFiles[tickerId]
        let s = "PRC \(field) \(price)\n"
        f.write(s.data(using: String.Encoding.utf8, allowLossyConversion: true)!);f.synchronizeFile()
    }
    func tickSize(_ tickerId: Int, field: Int, size: Int) {
        let f = outputFiles[tickerId]
        let s = "SZ  \(field) \(size)\n"
        f.write(s.data(using: String.Encoding.utf8, allowLossyConversion: true)!);f.synchronizeFile()
    }
    func tickGeneric(_ tickerId: Int, tickType: Int, value: Double) {
        let f = outputFiles[tickerId]
        let s = "GEN \(tickType) \(value)\n"
        f.write(s.data(using: String.Encoding.utf8, allowLossyConversion: true)!);f.synchronizeFile()
    }
    func tickString(_ tickerId: Int, tickType: Int, value: String) {
        let f = outputFiles[tickerId]
        var s = ""
        switch tickType {
        case 45:
            let tickI: Int? = Int(value)
            let tick: Double = tickI != nil ? Double(tickI!) : 0
            s = "STR TS \(LoggingWrapper.timeToStr(Date(timeIntervalSince1970: TimeInterval(tick)), millis:true))\n"
            
            default:
            s = "STR \(tickType) \(value)\n"
        }
        f.write(s.data(using: String.Encoding.utf8, allowLossyConversion: true)!);f.synchronizeFile()
    }
    func accountDownloadEnd(_ accountName: String){
        print("Account name \(accountName)")
    }

    // currently unused callbacks
    func tickOptionComputation(_ tickerId: Int, field: Int, impliedVol: Double, delta: Double, optPrice: Double, pvDividend: Double, gamma: Double, vega: Double, theta: Double, undPrice: Double) {}
    func tickEFP(_ tickerId: Int, tickType: Int, basisPoints: Double,
        formattedBasisPoints: String, impliedFuture: Double, holdDays: Int,
        futureExpiry: String, dividendImpact: Double, dividendsToExpiry: Double){}
    func orderStatus(_ orderId: Int, status: String, filled: Int, remaining: Int,
        avgFillPrice: Double, permId: Int, parentId: Int, lastFillPrice: Double,
        clientId: Int, whyHeld: String){}
    func openOrder(_ orderId: Int, contract: Contract, order: Order, orderState: OrderState){}
    func openOrderEnd(){}
    func updateAccountValue(_ key: String, value: String, currency: String, accountName: String){}
    func updatePortfolio(_ contract: Contract, position: Int, marketPrice: Double, marketValue: Double,
        averageCost: Double, unrealizedPNL: Double, realizedPNL: Double, accountName: String){}
    func updateAccountTime(_ timeStamp: String){}
    func nextValidId(_ orderId: Int){}
    func contractDetails(_ reqId: Int, contractDetails: ContractDetails){}
    func bondContractDetails(_ reqId: Int, contractDetails: ContractDetails){}
    func contractDetailsEnd(_ reqId: Int){}
    func execDetails(_ reqId: Int, contract: Contract, execution: Execution){}
    func execDetailsEnd(_ reqId: Int){}
    func updateMktDepth(_ tickerId: Int, position: Int, operation: Int, side: Int, price: Double, size: Int){}
    func updateMktDepthL2(_ tickerId: Int, position: Int, marketMaker: String, operation: Int,
        side: Int, price: Double, size: Int){}
    func updateNewsBulletin(_ msgId: Int, msgType: Int, message: String, origExchange: String){}
    func managedAccounts(_ accountsList: String){}
    func receiveFA(_ faDataType: Int, xml: String){}
    func historicalData(_ reqId: Int, date: String, open: Double, high: Double, low: Double,
        close: Double, volume: Int, count: Int, WAP: Double, hasGaps: Bool){}
    func scannerParameters(_ xml: String){}
    func scannerData(_ reqId: Int, rank: Int, contractDetails: ContractDetails, distance: String,
        benchmark: String, projection: String, legsStr: String){}
    func scannerDataEnd(_ reqId: Int){}
    func realtimeBar(_ reqId: Int, time: Int64, open: Double, high: Double, low: Double, close: Double, volume: Int64, wap: Double, count: Int) {}
    func currentTime(_ time: Int64){}
    func fundamentalData(_ reqId: Int, data: String){}
    func deltaNeutralValidation(_ reqId: Int, underComp: UnderComp){}
    func tickSnapshotEnd(_ reqId: Int){}
    func marketDataType(_ reqId: Int, marketDataType: Int){}
    func commissionReport(_ commissionReport: CommissionReport){}
    func position(_ account: String, contract: Contract, pos: Int, avgCost: Double){}
    func positionEnd(){}
    func accountSummary(_ reqId: Int, account: String, tag: String, value: String, currency: String){}
    func accountSummaryEnd(_ reqId: Int){}
    func verifyMessageAPI(_ apiData: String){}
    func verifyCompleted(_ isSuccessful: Bool, errorText: String){}
    func displayGroupList(_ reqId: Int, groups: String){}
    func displayGroupUpdated(_ reqId: Int, contractInfo: String){}

    // error handling
    func error( _ e: NSException) {}
    func error( _ str: String) {
        print("error: \(str)")
    }
    func error( _ id: Int, errorCode: Int, errorMsg:String) {
        print("error: id(\(id)) code(\(errorCode)) msg:\(errorMsg)")
    }
    func connectionClosed() {
        print("!!CONNECTION CLOSE")
        connected = false
    }

    class func timeToStr(_ time: Date, millis: Bool) -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = millis ? "yyyy-MM-dd HH:mm:ss.SSS zzz" : "yyyy-MM-dd HH:mm:ss zzz"
        return fmt.string(from: time)
    }
}

var connected = false
var host = "127.0.0.1"
var port: UInt32 = 7496
var tickers:[String] = []
var outputDir: String = FileManager.default.currentDirectoryPath
let filePrefix = LoggingWrapper.timeToStr(Date(timeIntervalSinceNow: 0), millis:false)

var argValue:[Bool] = [Bool](repeating: false, count: CommandLine.arguments.count)
var index = 1
for arg in CommandLine.arguments[1..<CommandLine.arguments.count] {
    switch arg {
    case "--host":
        if index+1<CommandLine.arguments.count {host = CommandLine.arguments[index+1]}
        argValue[index+1] = true
    case "--output":
        if index+1<CommandLine.arguments.count {outputDir = CommandLine.arguments[index+1]}
        argValue[index+1] = true
    case "--port":
        if index+1<CommandLine.arguments.count {
            if let p = Int(CommandLine.arguments[index+1]) {
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
    let outf = outputDir.appendingFormat("%@ %@.raw.dump", filePrefix, tickers[i]);
    var file = FileHandle(forWritingAtPath:outf)
    if file == nil {
        FileManager.default.createFile(atPath: outf, contents: nil, attributes: nil)
        file = FileHandle(forWritingAtPath:outf)
    }
    if file != nil {
        outputFiles.append(file!)
        let s = "SYMBOL \(tickers[i]) \n"
        file!.write(s.data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        file!.synchronizeFile()
    }
}
if outputFiles.count != tickers.count {
    print("Error: cannot correct output files")
    NSApplication.shared.terminate(nil)
}

while true {
    let wrapper = LoggingWrapper()
    let client = EClientSocket(p_eWrapper: wrapper, p_anyWrapper: wrapper)
    print("Connecting to IB API...")
    client.eConnect(host, p_port: port)
    connected = true
    for i in 0 ..< tickers.count {
        let con = Contract(p_conId: 0, p_symbol: tickers[i], p_secType: "STK", p_expiry: "", p_strike: 0.0, p_right: "", p_multiplier: "",
            p_exchange: "SMART", p_currency: "USD", p_localSymbol: tickers[i], p_tradingClass: "", p_comboLegs: nil, p_primaryExch: "ISLAND",
            p_includeExpired: true, p_secIdType: "", p_secId: "")
        // tickerId is strickly 0..<tickers.count
        client.reqMktData(i, contract: con, genericTickList: "", snapshot: false, mktDataOptions: nil)
    }
    while connected { Thread.sleep(forTimeInterval: TimeInterval(3.0)) }
    client.eDisconnect()
    client.close()
}

//
//  EClientSocket.swift
//  SwiftIB
//
//  Created by Harry Li on 2/01/2015.
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

// Client version history
//
// 	6 = Added parentId to orderStatus
// 	7 = The new execDetails event returned for an order filled status and reqExecDetails
//     Also market depth is available.
// 	8 = Added lastFillPrice to orderStatus() event and permId to execution details
//  9 = Added 'averageCost', 'unrealizedPNL', and 'unrealizedPNL' to updatePortfolio event
// 10 = Added 'serverId' to the 'open order' & 'order status' events.
//      We send back all the API open orders upon connection.
//      Added new methods reqAllOpenOrders, reqAutoOpenOrders()
//      Added FA support - reqExecution has filter.
//                       - reqAccountUpdates takes acct code.
// 11 = Added permId to openOrder event.
// 12 = requsting open order attributes ignoreRth, hidden, and discretionary
// 13 = added goodAfterTime
// 14 = always send size on bid/ask/last tick
// 15 = send allocation description string on openOrder
// 16 = can receive account name in account and portfolio updates, and fa params in openOrder
// 17 = can receive liquidation field in exec reports, and notAutoAvailable field in mkt data
// 18 = can receive good till date field in open order messages, and request intraday backfill
// 19 = can receive rthOnly flag in ORDER_STATUS
// 20 = expects TWS time string on connection after server version >= 20.
// 21 = can receive bond contract details.
// 22 = can receive price magnifier in version 2 contract details message
// 23 = support for scanner
// 24 = can receive volatility order parameters in open order messages
// 25 = can receive HMDS query start and end times
// 26 = can receive option vols in option market data messages
// 27 = can receive delta neutral order type and delta neutral aux price in place order version 20: API 8.85
// 28 = can receive option model computation ticks: API 8.9
// 29 = can receive trail stop limit price in open order and can place them: API 8.91
// 30 = can receive extended bond contract def, new ticks, and trade count in bars
// 31 = can receive EFP extensions to scanner and market data, and combo legs on open orders
//    ; can receive RT bars
// 32 = can receive TickType.LAST_TIMESTAMP
//    ; can receive "whyHeld" in order status messages
// 33 = can receive ScaleNumComponents and ScaleComponentSize is open order messages
// 34 = can receive whatIf orders / order state
// 35 = can receive contId field for Contract objects
// 36 = can receive outsideRth field for Order objects
// 37 = can receive clearingAccount and clearingIntent for Order objects
// 38 = can receive multiplier and primaryExchange in portfolio updates
//    ; can receive cumQty and avgPrice in execution
//    ; can receive fundamental data
//    ; can receive underComp for Contract objects
//    ; can receive reqId and end marker in contractDetails/bondContractDetails
//    ; can receive ScaleInitComponentSize and ScaleSubsComponentSize for Order objects
// 39 = can receive underConId in contractDetails
// 40 = can receive algoStrategy/algoParams in openOrder
// 41 = can receive end marker for openOrder
//    ; can receive end marker for account download
//    ; can receive end marker for executions download
// 42 = can receive deltaNeutralValidation
// 43 = can receive longName(companyName)
//    ; can receive listingExchange
//    ; can receive RTVolume tick
// 44 = can receive end market for ticker snapshot
// 45 = can receive notHeld field in openOrder
// 46 = can receive contractMonth, industry, category, subcategory fields in contractDetails
//    ; can receive timeZoneId, tradingHours, liquidHours fields in contractDetails
// 47 = can receive gamma, vega, theta, undPrice fields in TICK_OPTION_COMPUTATION
// 48 = can receive exemptCode in openOrder
// 49 = can receive hedgeType and hedgeParam in openOrder
// 50 = can receive optOutSmartRouting field in openOrder
// 51 = can receive smartComboRoutingParams in openOrder
// 52 = can receive deltaNeutralConId, deltaNeutralSettlingFirm, deltaNeutralClearingAccount and deltaNeutralClearingIntent in openOrder
// 53 = can receive orderRef in execution
// 54 = can receive scale order fields (PriceAdjustValue, PriceAdjustInterval, ProfitOffset, AutoReset,
//      InitPosition, InitFillQty and RandomPercent) in openOrder
// 55 = can receive orderComboLegs (price) in openOrder
// 56 = can receive trailingPercent in openOrder
// 57 = can receive commissionReport message
// 58 = can receive CUSIP/ISIN/etc. in contractDescription/bondContractDescription
// 59 = can receive evRule, evMultiplier in contractDescription/bondContractDescription/executionDetails
//      can receive multiplier in executionDetails
// 60 = can receive deltaNeutralOpenClose, deltaNeutralShortSale, deltaNeutralShortSaleSlot and deltaNeutralDesignatedLocation in openOrder
// 61 = can receive multiplier in openOrder
//      can receive tradingClass in openOrder, updatePortfolio, execDetails and position
// 62 = can receive avgCost in position message
// 63 = can receive verifyMessageAPI, verifyCompleted, displayGroupList and displayGroupUpdated messages

let CLIENT_VERSION: Int = 63
let SERVER_VERSION: Int = 38
let EOL: [Byte] = [0]
let BAG_SEC_TYPE: String = "BAG"

let GROUPS: Int = 1
let PROFILES: Int = 2
let ALIASES: Int = 3

class EClientSocket {
    
    class func faMsgTypeName(faDataType: Int) -> String {
        switch (faDataType) {
        case 1:
            return "GROUPS"
        case 2:
            return "PROFILES"
        case 3:
            return "ALIASES"
        default:
            return ""
        }
    }
    
    // outgoing msg id's
    let REQ_MKT_DATA = 1
    let CANCEL_MKT_DATA = 2
    let PLACE_ORDER = 3
    let CANCEL_ORDER = 4
    let REQ_OPEN_ORDERS = 5
    let REQ_ACCOUNT_DATA = 6
    let REQ_EXECUTIONS = 7
    let REQ_IDS = 8
    let REQ_CONTRACT_DATA = 9
    let REQ_MKT_DEPTH = 10
    let CANCEL_MKT_DEPTH = 11
    let REQ_NEWS_BULLETINS = 12
    let CANCEL_NEWS_BULLETINS = 13
    let SET_SERVER_LOGLEVEL = 14
    let REQ_AUTO_OPEN_ORDERS = 15
    let REQ_ALL_OPEN_ORDERS = 16
    let REQ_MANAGED_ACCTS = 17
    let REQ_FA = 18
    let REPLACE_FA = 19
    let REQ_HISTORICAL_DATA = 20
    let EXERCISE_OPTIONS = 21
    let REQ_SCANNER_SUBSCRIPTION = 22
    let CANCEL_SCANNER_SUBSCRIPTION = 23
    let REQ_SCANNER_PARAMETERS = 24
    let CANCEL_HISTORICAL_DATA = 25
    let REQ_CURRENT_TIME = 49
    let REQ_REAL_TIME_BARS = 50
    let CANCEL_REAL_TIME_BARS = 51
    let REQ_FUNDAMENTAL_DATA = 52
    let CANCEL_FUNDAMENTAL_DATA = 53
    let REQ_CALC_IMPLIED_VOLAT = 54
    let REQ_CALC_OPTION_PRICE = 55
    let CANCEL_CALC_IMPLIED_VOLAT = 56
    let CANCEL_CALC_OPTION_PRICE = 57
    let REQ_GLOBAL_CANCEL = 58
    let REQ_MARKET_DATA_TYPE = 59
    let REQ_POSITIONS = 61
    let REQ_ACCOUNT_SUMMARY = 62
    let CANCEL_ACCOUNT_SUMMARY = 63
    let CANCEL_POSITIONS = 64
    let VERIFY_REQUEST = 65
    let VERIFY_MESSAGE = 66
    let QUERY_DISPLAY_GROUPS = 67
    let SUBSCRIBE_TO_GROUP_EVENTS = 68
    let UPDATE_DISPLAY_GROUP = 69
    let UNSUBSCRIBE_FROM_GROUP_EVENTS = 70
    let START_API = 71
    
    let MIN_SERVER_VER_REAL_TIME_BARS = 34
    let MIN_SERVER_VER_SCALE_ORDERS = 35
    let MIN_SERVER_VER_SNAPSHOT_MKT_DATA = 35
    let MIN_SERVER_VER_SSHORT_COMBO_LEGS = 35
    let MIN_SERVER_VER_WHAT_IF_ORDERS = 36
    let MIN_SERVER_VER_CONTRACT_CONID = 37
    let MIN_SERVER_VER_PTA_ORDERS = 39
    let MIN_SERVER_VER_FUNDAMENTAL_DATA = 40
    let MIN_SERVER_VER_UNDER_COMP = 40
    let MIN_SERVER_VER_CONTRACT_DATA_CHAIN = 40
    let MIN_SERVER_VER_SCALE_ORDERS2 = 40
    let MIN_SERVER_VER_ALGO_ORDERS = 41
    let MIN_SERVER_VER_EXECUTION_DATA_CHAIN = 42
    let MIN_SERVER_VER_NOT_HELD = 44
    let MIN_SERVER_VER_SEC_ID_TYPE = 45
    let MIN_SERVER_VER_PLACE_ORDER_CONID = 46
    let MIN_SERVER_VER_REQ_MKT_DATA_CONID = 47
    let MIN_SERVER_VER_REQ_CALC_IMPLIED_VOLAT = 49
    let MIN_SERVER_VER_REQ_CALC_OPTION_PRICE = 50
    let MIN_SERVER_VER_CANCEL_CALC_IMPLIED_VOLAT = 50
    let MIN_SERVER_VER_CANCEL_CALC_OPTION_PRICE = 50
    let MIN_SERVER_VER_SSHORTX_OLD = 51
    let MIN_SERVER_VER_SSHORTX = 52
    let MIN_SERVER_VER_REQ_GLOBAL_CANCEL = 53
    let MIN_SERVER_VER_HEDGE_ORDERS = 54
    let MIN_SERVER_VER_REQ_MARKET_DATA_TYPE = 55
    let MIN_SERVER_VER_OPT_OUT_SMART_ROUTING = 56
    let MIN_SERVER_VER_SMART_COMBO_ROUTING_PARAMS = 57
    let MIN_SERVER_VER_DELTA_NEUTRAL_CONID = 58
    let MIN_SERVER_VER_SCALE_ORDERS3 = 60
    let MIN_SERVER_VER_ORDER_COMBO_LEGS_PRICE = 61
    let MIN_SERVER_VER_TRAILING_PERCENT = 62
    let MIN_SERVER_VER_DELTA_NEUTRAL_OPEN_CLOSE = 66
    let MIN_SERVER_VER_ACCT_SUMMARY = 67
    let MIN_SERVER_VER_TRADING_CLASS = 68
    let MIN_SERVER_VER_SCALE_TABLE = 69
    let MIN_SERVER_VER_LINKING = 70
    
    private var _eWrapper : EWrapper // msg handler
    private var _anyWrapper : AnyWrapper // msg handler
    private var dos : NSOutputStream? = nil // the socket output stream
    private var connected : Bool = false    // true if we are connected
    private var _reader : EReader? = nil    // thread which reads msgs from socket
    private var _serverVersion : Int = 0
    private var TwsTime : String = ""
    private var clientId : Int = 0
    private var extraAuth : Bool = false
    
    func serverVersion() -> Int { return _serverVersion }
    func TwsConnectionTime() -> String { return TwsTime }
    func anyWrapper() -> AnyWrapper { return _anyWrapper }
    func eWrapper() -> EWrapper { return _eWrapper }
    func reader() -> EReader? { return _reader? }
    func isConnected() -> Bool { return connected }
    func outputStream() -> NSOutputStream? { return dos }
    
    init(p_eWrapper: EWrapper, p_anyWrapper: AnyWrapper) {
        _anyWrapper = p_anyWrapper
        _eWrapper = p_eWrapper
    }
    
    func setExtraAuth(p_extraAuth: Bool) {
        extraAuth = p_extraAuth
    }
    
    func eConnect(host: String, port: Int, clientId: Int) { // synchronized
        self.eConnect(host, p_port: port, p_clientId: clientId, p_extraAuth: false)
    }
    
    func eConnect(p_host: String, p_port: Int, p_clientId: Int, p_extraAuth: Bool) { // synchronized
        // already connected?
        let host = checkConnected(p_host)
        var port : UInt32 = 0
        if p_port > 0 { port = UInt32(p_port) }
        
        clientId = p_clientId
        extraAuth = p_extraAuth
        
        if host.isEmpty {
            return
        }
        
        self.eConnect(p_host, p_port: port)
        // TODO: Handle errors here
        //    catch( Exception e) {
        //    eDisconnect()
        //    connectionError()
        //    }
    }
    
    func connectionError() {
        _anyWrapper.error(EClientErrors_NO_VALID_ID, errorCode: EClientErrors_CONNECT_FAIL.code,
            errorMsg: EClientErrors_CONNECT_FAIL.msg)
        _reader = nil
    }
    
    func checkConnected(host: String) -> String {
        if connected {
            _anyWrapper.error(EClientErrors_NO_VALID_ID, errorCode: EClientErrors_ALREADY_CONNECTED.code,
                errorMsg: EClientErrors_ALREADY_CONNECTED.msg)
            return ""
        }
        if host.isEmpty {
            return "127.0.0.1"
        }
        return host
    }
    
    func createReader(socket: EClientSocket, dis: NSInputStream) -> EReader {
        return EReader(parent: socket, dis: dis)
    }
    
    func eConnect(p_host: String, p_port: UInt32) { // synchronized
        
        // create io streams
        var readStream:  Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        var host: CFString = p_host
        
        CFStreamCreatePairWithSocketToHost(nil, host, p_port, &readStream, &writeStream)
        var dis : NSInputStream = readStream!.takeRetainedValue()
        self.dos = writeStream!.takeRetainedValue()
        
        // TODO: add delegates here
        //        self.inputStream.delegate = self
        //        self.outputStream.delegate = self
        
        dis.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        dos?.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        dis.open()
        dos?.open()
        
        // set client version
        send(CLIENT_VERSION)
        
        // start reader thread
        _reader = createReader(self, dis: dis)
        
        // check server version
        _serverVersion = (_reader?.readInt())!
        println("Server Version: \(_serverVersion)")
        if _serverVersion >= 20 {
            if let ttime = _reader?.readStr() {
                TwsTime = ttime
            }
            println("TWS Time at connection: \(TwsTime)")
        }
        if (_serverVersion < SERVER_VERSION) {
            eDisconnect()
            _anyWrapper.error(EClientErrors_NO_VALID_ID, errorCode: EClientErrors_UPDATE_TWS.code, errorMsg: EClientErrors_UPDATE_TWS.msg)
            return
        }
        
        // set connected flag
        connected = true;
        
        // Send the client id
        if _serverVersion >= 3 {
            if _serverVersion < MIN_SERVER_VER_LINKING {
                send(clientId)
            }
            else if (!extraAuth){
                startAPI()
            }
        }
        
        _reader?.start()
        
    }
    
    func eDisconnect() { // synchronized
        // not connected?
        if dos == nil {
            return
        }
        
        connected = false
        extraAuth = false
        clientId = -1
        _serverVersion = 0
        TwsTime = ""
        
        var pdos = dos
        dos = nil
        
        var preader = _reader
        _reader = nil
        
        // stop reader thread; reader thread will close input stream
        if preader != nil {
            preader?.cancel()
        }
        
        // close output stream
        if preader != nil {
            pdos?.close()
        }
    }
    
    func startAPI() { // synchronized
        // not connected?
        if !connected {
            notConnected()
            return
        }
        
        let VERSION = 1
        
        send(START_API)
        send(VERSION)
        send(clientId)
        
        // TODO: Handle errors here
        //    catch( Exception e) {
        //    error( EClientErrors_NO_VALID_ID,
        //    EClientErrors_FAIL_SEND_STARTAPI, "" + e)
        //    close()
        //    }
    }
    
    func cancelScannerSubscription(tickerId: Int) { // synchronized
        // not connected?
        if !connected {
            notConnected()
            return
        }
        
        if _serverVersion < 24 {
            error(EClientErrors_NO_VALID_ID, pair: EClientErrors_UPDATE_TWS,
                tail: "  It does not support API scanner subscription.")
            return
        }
        
        let VERSION = 1
        
        // send cancel mkt data msg
        send(CANCEL_SCANNER_SUBSCRIPTION)
        send(VERSION)
        send(tickerId)
        // TODO: Handle errors here
//        catch( Exception e) {
//            error( tickerId, EClientErrors_FAIL_SEND_CANSCANNER, "" + e)
//            close()
//        }
    }
    
    func reqScannerParameters() { // synchronized
        // not connected?
        if !connected {
            notConnected()
            return
        }
        
        if (_serverVersion < 24) {
            error(EClientErrors_NO_VALID_ID, pair: EClientErrors_UPDATE_TWS,
                tail: "  It does not support API scanner subscription.")
            return
        }
        
        let VERSION = 1
        
        send(REQ_SCANNER_PARAMETERS)
        send(VERSION)
        // TODO: Handle errors here
//        catch( Exception e) {
//            error( EClientErrors_NO_VALID_ID,
//                EClientErrors_FAIL_SEND_REQSCANNERPARAMETERS, "" + e)
//            close()
//        }
    }
    
    func reqScannerSubscription(tickerId: Int, subscription: ScannerSubscription, scannerSubscriptionOptions: [TagValue]?) { // synchronized
        // not connected?
        if !connected {
            notConnected()
            return
        }
        
        if _serverVersion < 24 {
            error(EClientErrors_NO_VALID_ID, pair: EClientErrors_UPDATE_TWS,
                tail: "  It does not support API scanner subscription.")
            return
        }
        
        let VERSION = 4
        
            send(REQ_SCANNER_SUBSCRIPTION)
            send(VERSION)
            send(tickerId)
            sendMax(subscription.numberOfRows)
            send(subscription.instrument)
            send(subscription.locationCode)
            send(subscription.scanCode)
            sendMax(subscription.abovePrice)
            sendMax(subscription.belowPrice)
            sendMax(subscription.aboveVolume)
            sendMax(subscription.marketCapAbove)
            sendMax(subscription.marketCapBelow)
            send(subscription.moodyRatingAbove)
            send(subscription.moodyRatingBelow)
            send(subscription.spRatingAbove)
            send(subscription.spRatingBelow)
            send(subscription.maturityDateAbove)
            send(subscription.maturityDateBelow)
            sendMax(subscription.couponRateAbove)
            sendMax(subscription.couponRateBelow)
            send(subscription.excludeConvertible)
            if _serverVersion >= 25 {
                sendMax(subscription.averageOptionVolumeAbove)
                send(subscription.scannerSettingPairs)
            }
            if _serverVersion >= 27 {
                send(subscription.stockTypeFilter)
            }
            
            // send scannerSubscriptionOptions parameter
            if _serverVersion >= MIN_SERVER_VER_LINKING {
                var scannerSubscriptionOptionsStr = ""
                if scannerSubscriptionOptions != nil {
                    let scannerSubscriptionOptionsCount = scannerSubscriptionOptions!.count
                    if scannerSubscriptionOptionsCount > 0 {
                        for i in 1...scannerSubscriptionOptionsCount {
                            let tagValue = scannerSubscriptionOptions![i-1]
                            scannerSubscriptionOptionsStr += tagValue.tag
                            scannerSubscriptionOptionsStr += "="
                            scannerSubscriptionOptionsStr += tagValue.value
                            scannerSubscriptionOptionsStr += ";"
                        }
                    }
                }
                send( scannerSubscriptionOptionsStr )
            }

        // TODO: Handle errors here
//        catch( Exception e) {
//            error( tickerId, EClientErrors_FAIL_SEND_REQSCANNER, "" + e)
//            close()
//        }
    }
    
    func reqMktData(tickerId: Int, contract: Contract, genericTickList: String, snapshot: Bool, mktDataOptions: [TagValue]?) { // synchronized
        if !connected {
            error(EClientErrors_NO_VALID_ID, pair: EClientErrors_NOT_CONNECTED, tail: "")
            return
        }
    
        if _serverVersion < MIN_SERVER_VER_SNAPSHOT_MKT_DATA && snapshot {
            error(tickerId, pair: EClientErrors_UPDATE_TWS,
                tail: "  It does not support snapshot market data requests.")
            return
        }
    
        if _serverVersion < MIN_SERVER_VER_UNDER_COMP {
            if contract.underComp != nil {
                error(tickerId, pair: EClientErrors_UPDATE_TWS,
                    tail: "  It does not support delta-neutral orders.")
                return
            }
        }
    
        if _serverVersion < MIN_SERVER_VER_REQ_MKT_DATA_CONID {
            if contract.conId > 0 {
                error(tickerId, pair: EClientErrors_UPDATE_TWS,
                    tail: "  It does not support conId parameter.")
                return
            }
        }
    
        if _serverVersion < MIN_SERVER_VER_TRADING_CLASS {
            if !contract.tradingClass.isEmpty {
                error(tickerId, pair: EClientErrors_UPDATE_TWS,
                    tail: "  It ot support tradingClass parameter in reqMarketData.")
                return
            }
        }
    
        let VERSION = 11
    
        // send req mkt data msg
        send(REQ_MKT_DATA)
        send(VERSION)
        send(tickerId)
    
        // send contract fields
        if _serverVersion >= MIN_SERVER_VER_REQ_MKT_DATA_CONID {
            send(contract.conId)
        }
        send(contract.symbol)
        send(contract.secType)
        send(contract.expiry)
        send(contract.strike)
        send(contract.right)
        if _serverVersion >= 15 {
            send(contract.multiplier)
        }
        send(contract.exchange)
        if _serverVersion >= 14 {
            send(contract.primaryExch)
        }
        send(contract.currency)
        if _serverVersion >= 2 {
            send(contract.localSymbol)
        }
        if _serverVersion >= MIN_SERVER_VER_TRADING_CLASS {
            send(contract.tradingClass)
        }
        if _serverVersion >= 8 && caseInsensitiveEqual(contract.secType, BAG_SEC_TYPE) {
            send(contract.comboLegs.count)
            
            for i in 1...contract.comboLegs.count {
                let comboLeg = contract.comboLegs[i]
                send(comboLeg.conId)
                send(comboLeg.ratio)
                send(comboLeg.action)
                send(comboLeg.exchange)
            }
        }
        
        if _serverVersion >= MIN_SERVER_VER_UNDER_COMP {
            if let underComp = contract.underComp {
                send(true)
                send(underComp.conId)
                send(underComp.delta)
                send(underComp.price)
            }
            else {
                send( false)
            }
        }
        
        if _serverVersion >= 31 {
            /*
            * Note: Even though SHORTABLE tick type supported only
            *       starting server version 33 it would be relatively
            *       expensive to expose this restriction here.
            *
            *       Therefore we are relying on TWS doing validation.
            */
            send( genericTickList)
        }
        if _serverVersion >= MIN_SERVER_VER_SNAPSHOT_MKT_DATA {
            send (snapshot)
        }
        
        // send mktDataOptions parameter
        if _serverVersion >= MIN_SERVER_VER_LINKING {
            var mktDataOptionsStr = ""
            if mktDataOptions != nil {
                let mktDataOptionsCount = mktDataOptions!.count
                for i in 1...mktDataOptionsCount {
                    let tagValue = mktDataOptions![i]
                    mktDataOptionsStr += tagValue.tag
                    mktDataOptionsStr += "="
                    mktDataOptionsStr += tagValue.value
                    mktDataOptionsStr += ";"
                }
            }
            send( mktDataOptionsStr )
        }
        
        // TODO: Handle errors here
        //        catch( Exception e) {
        //        error( tickerId, EClientErrors_FAIL_SEND_REQMKT, "" + e)
        //        close()
        //        }
    }
    
    func cancelHistoricalData(tickerId :Int) { // synchronized
        // not connected?
        if !connected {
            notConnected()
            return
        }
    
        if _serverVersion < 24 {
            error(EClientErrors_NO_VALID_ID, pair: EClientErrors_UPDATE_TWS,
                tail: "  It does not support historical data query cancellation.")
            return
        }
    
        let VERSION = 1
    
        // send cancel mkt data msg
        send(CANCEL_HISTORICAL_DATA)
        send(VERSION)
        send(tickerId)
        // TODO: Handle errors here
//        catch( Exception e) {
//        error( tickerId, EClientErrors_FAIL_SEND_CANHISTDATA, "" + e)
//        close()
//        }
    }
    
    func cancelRealTimeBars(tickerId: Int) { // synchronized
        // not connected?
        if !connected {
            notConnected()
            return
        }
    
        if _serverVersion < MIN_SERVER_VER_REAL_TIME_BARS {
            error(EClientErrors_NO_VALID_ID, pair: EClientErrors_UPDATE_TWS,
                tail: "  It does not support realtime bar data query cancellation.")
            return
        }
    
        let VERSION = 1
    
        // send cancel mkt data msg
        send( CANCEL_REAL_TIME_BARS)
        send( VERSION)
        send( tickerId)
        // Handle errors here
//        catch( Exception e) {
//        error( tickerId, EClientErrors_FAIL_SEND_CANRTBARS, "" + e)
//        close()
//        }
    }
    
        /** Note that formatData parameter affects intra-day bars only; 1-day bars always return with date in YYYYMMDD format. */
    func reqHistoricalData(tickerId: Int, contract: Contract,
        endDateTime: String, durationStr: String,
        barSizeSetting: String, whatToShow: String,
        useRTH: Int, formatDate: Int, chartOptions: [TagValue]?) { // synchronized
        // not connected?
        if !connected {
            notConnected()
            return
        }
    
        let VERSION = 6
    
        if _serverVersion < 16 {
            error(EClientErrors_NO_VALID_ID, pair: EClientErrors_UPDATE_TWS,
                tail: "  It does not support historical data backfill.")
            return
        }
    
        if _serverVersion < MIN_SERVER_VER_TRADING_CLASS {
            if ((contract.tradingClass.isEmpty == false) || (contract.conId > 0)) {
                error(tickerId, pair: EClientErrors_UPDATE_TWS,
                    tail: "  It does not support conId and tradingClass parameters in reqHistroricalData.")
                return
            }
        }
    
        send(REQ_HISTORICAL_DATA)
        send(VERSION)
        send(tickerId)
    
        // send contract fields
        if _serverVersion >= MIN_SERVER_VER_TRADING_CLASS {
            send(contract.conId)
        }
        send(contract.symbol)
        send(contract.secType)
        send(contract.expiry)
        send(contract.strike)
        send(contract.right)
        send(contract.multiplier)
        send(contract.exchange)
        send(contract.primaryExch)
        send(contract.currency)
        send(contract.localSymbol)
        if _serverVersion >= MIN_SERVER_VER_TRADING_CLASS {
            send(contract.tradingClass)
        }
        if _serverVersion >= 31 {
            send(contract.includeExpired ? 1 : 0)
        }
        if _serverVersion >= 20 {
            send(endDateTime)
            send(barSizeSetting)
        }
        send(durationStr)
        send(useRTH)
        send(whatToShow)
        if _serverVersion > 16 {
            send(formatDate)
        }
        if (caseInsensitiveEqual(BAG_SEC_TYPE, contract.secType)) {
            send(contract.comboLegs.count)
            for i in 1...contract.comboLegs.count {
                let comboLeg = contract.comboLegs[i - 1]
                send(comboLeg.conId)
                send(comboLeg.ratio)
                send(comboLeg.action)
                send(comboLeg.exchange)
            }
        }
    
        // send chartOptions parameter
        if _serverVersion >= MIN_SERVER_VER_LINKING {
            var chartOptionsStr = ""
            if chartOptions != nil {
                let chartOptionsCount = chartOptions!.count
                for i in 1...chartOptionsCount {
                    let tagValue = chartOptions![i]
                    chartOptionsStr += tagValue.tag
                    chartOptionsStr += "="
                    chartOptionsStr += tagValue.value
                    chartOptionsStr += ";"
                }
            }
            send(chartOptionsStr)
        }
    

        // TODO: Handle errors here
//        catch (Exception e) {
//        error(tickerId, EClientErrors_FAIL_SEND_REQHISTDATA, "" + e)
//        close()
//        }
    }
    
    func reqRealTimeBars(tickerId: Int, contract: Contract, barSize: Int, whatToShow: String, useRTH: Bool, realTimeBarsOptions: [TagValue]?) { // synchronized
        // not connected?
        if !connected {
            notConnected()
            return
        }
        
        if _serverVersion < MIN_SERVER_VER_REAL_TIME_BARS {
            error(EClientErrors_NO_VALID_ID, pair: EClientErrors_UPDATE_TWS,
                tail: "  It does not support real time bars.")
            return
        }
        if _serverVersion < MIN_SERVER_VER_TRADING_CLASS {
            if ((contract.tradingClass.isEmpty == false) || (contract.conId > 0)) {
                error(tickerId, pair: EClientErrors_UPDATE_TWS,
                    tail: "  It does not support conId and tradingClass parameters in reqRealTimeBars.")
                return
            }
        }
        
        let VERSION = 3
        
        // send req mkt data msg
        send(REQ_REAL_TIME_BARS)
        send(VERSION)
        send(tickerId)
        
        // send contract fields
        if _serverVersion >= MIN_SERVER_VER_TRADING_CLASS {
            send(contract.conId)
        }
        send(contract.symbol)
        send(contract.secType)
        send(contract.expiry)
        send(contract.strike)
        send(contract.right)
        send(contract.multiplier)
        send(contract.exchange)
        send(contract.primaryExch)
        send(contract.currency)
        send(contract.localSymbol)
        if _serverVersion >= MIN_SERVER_VER_TRADING_CLASS {
            send(contract.tradingClass)
        }
        send(barSize)  // this parameter is not currently used
        send(whatToShow)
        send(useRTH)
        
        // send realTimeBarsOptions parameter
        if _serverVersion >= MIN_SERVER_VER_LINKING {
            var realTimeBarsOptionsStr = ""
            if realTimeBarsOptions != nil {
                var realTimeBarsOptionsCount = realTimeBarsOptions!.count
                for i in 1...realTimeBarsOptionsCount {
                    let tagValue = realTimeBarsOptions![i]
                    realTimeBarsOptionsStr += tagValue.tag
                    realTimeBarsOptionsStr += "="
                    realTimeBarsOptionsStr += tagValue.value
                    realTimeBarsOptionsStr += ";"
                }
            }
            send(realTimeBarsOptionsStr)
        }
        
        // TODO: Handle errors here
        //catch( Exception e) {
        //error( tickerId, EClientErrors_FAIL_SEND_REQRTBARS, "" + e)
        //close()
        //}
    }
    
    func reqContractDetails(reqId: Int, contract: Contract) { // synchronized
        // not connected?
        if !connected {
            notConnected()
            return
        }
    
        // This feature is only available for versions of TWS >=4
        if (_serverVersion < 4) {
            error(EClientErrors_NO_VALID_ID, errorCode: EClientErrors_UPDATE_TWS.code,
                errorMsg: EClientErrors_UPDATE_TWS.msg)
            return
        }
    
        if (_serverVersion < MIN_SERVER_VER_SEC_ID_TYPE) {
            if ((contract.secIdType.isEmpty == false) ||
                (contract.secId.isEmpty == false)) {
                    error(reqId, pair: EClientErrors_UPDATE_TWS,
                        tail: "  It does not support secIdType and secId parameters.")
                    return
                }
        }
    
        if _serverVersion < MIN_SERVER_VER_TRADING_CLASS {
            if (contract.tradingClass.isEmpty == false) {
                error(reqId, pair: EClientErrors_UPDATE_TWS,
                    tail: "  It does not support tradingClass parameter in reqContractDetails.")
                return
            }
        }
    
        let VERSION = 7
    
        // send req mkt data msg
        send(REQ_CONTRACT_DATA)
        send(VERSION)
    
        if _serverVersion >= MIN_SERVER_VER_CONTRACT_DATA_CHAIN {
            send(reqId)
        }
    
        // send contract fields
        if _serverVersion >= MIN_SERVER_VER_CONTRACT_CONID {
            send(contract.conId)
        }
        send(contract.symbol)
        send(contract.secType)
        send(contract.expiry)
        send(contract.strike)
        send(contract.right)
        if _serverVersion >= 15 {
            send(contract.multiplier)
        }
        send(contract.exchange)
        send(contract.currency)
        send(contract.localSymbol)
        if _serverVersion >= MIN_SERVER_VER_TRADING_CLASS {
            send(contract.tradingClass)
        }
        if _serverVersion >= 31 {
            send(contract.includeExpired)
        }
        if _serverVersion >= MIN_SERVER_VER_SEC_ID_TYPE {
            send(contract.secIdType)
            send(contract.secId)
        }
    
        // TODO: Handle errors here
        //catch( Exception e) {
        //error( EClientErrors_NO_VALID_ID, EClientErrors_FAIL_SEND_REQCONTRACT, "" + e)
        //close()
        //}
    }
    
    func reqMktDepth(tickerId: Int, contract: Contract, numRows: Int, mktDepthOptions: [TagValue]?) { // synchronized
        // not connected?
        if !connected {
            notConnected()
            return
        }
    
        // This feature is only available for versions of TWS >=6
        if (_serverVersion < 6) {
            error(EClientErrors_NO_VALID_ID, errorCode: EClientErrors_UPDATE_TWS.code,
                errorMsg: EClientErrors_UPDATE_TWS.msg)
            return
        }
    
        if _serverVersion < MIN_SERVER_VER_TRADING_CLASS {
            if ((contract.tradingClass.isEmpty == false) || (contract.conId > 0)) {
                error(tickerId, pair: EClientErrors_UPDATE_TWS,
                    tail: "  It does not support conId and tradingClass parameters in reqMktDepth.")
                return
            }
        }
    
        let VERSION = 5
    
        // send req mkt data msg
        send(REQ_MKT_DEPTH)
        send(VERSION)
        send(tickerId)
    
        // send contract fields
        if _serverVersion >= MIN_SERVER_VER_TRADING_CLASS {
            send(contract.conId)
        }
        send(contract.symbol)
        send(contract.secType)
        send(contract.expiry)
        send(contract.strike)
        send(contract.right)
        if _serverVersion >= 15 {
            send(contract.multiplier)
        }
        send(contract.exchange)
        send(contract.currency)
        send(contract.localSymbol)
        if _serverVersion >= MIN_SERVER_VER_TRADING_CLASS {
            send(contract.tradingClass)
        }
        if _serverVersion >= 19 {
            send(numRows)
        }
    
        // send mktDepthOptions parameter
        if _serverVersion >= MIN_SERVER_VER_LINKING {
            var mktDepthOptionsStr = ""
            if mktDepthOptions != nil {
                var mktDepthOptionsCount = mktDepthOptions!.count
                for i in 1...mktDepthOptionsCount {
                    let tagValue = mktDepthOptions![i]
                    mktDepthOptionsStr += tagValue.tag
                    mktDepthOptionsStr += "="
                    mktDepthOptionsStr += tagValue.value
                    mktDepthOptionsStr += ";"
                }
            }
            send(mktDepthOptionsStr)
        }
    
        // TODO: Handle errors here
        //catch( Exception e) {
        //error( tickerId, EClientErrors_FAIL_SEND_REQMKTDEPTH, "" + e)
        //close()
        //}
        }
    
    func cancelMktData(tickerId: Int) { // synchronized
        // not connected?
        if !connected {
            notConnected()
            return
        }
    
        let VERSION = 1
    
        // send cancel mkt data msg
        send(CANCEL_MKT_DATA)
        send(VERSION)
        send(tickerId)
        // TODO: Handle errors here
        //catch( Exception e) {
        //error( tickerId, EClientErrors_FAIL_SEND_CANMKT, "" + e)
        //close()
        //}
    }
    
    func cancelMktDepth(tickerId: Int) { // synchronized
        // not connected?
        if !connected {
            notConnected()
            return
        }
    
        // This feature is only available for versions of TWS >=6
        if (_serverVersion < 6) {
            error(EClientErrors_NO_VALID_ID, errorCode: EClientErrors_UPDATE_TWS.code,
                errorMsg: EClientErrors_UPDATE_TWS.msg)
            return
        }
    
        let VERSION = 1
    
        // send cancel mkt data msg
        send(CANCEL_MKT_DEPTH)
        send(VERSION)
        send(tickerId)
        // TODO: Handle errors here
        //catch( Exception e) {
        //error( tickerId, EClientErrors_FAIL_SEND_CANMKTDEPTH, "" + e)
        //close()
        //}
    }
    
    func exerciseOptions(tickerId: Int, contract: Contract,
        exerciseAction: Int, exerciseQuantity: Int,
        account: String, override: Int) { // synchronized
        // not connected?
        if !connected {
            notConnected()
            return
        }
    
        let VERSION = 2
    
        if _serverVersion < 21 {
            error(EClientErrors_NO_VALID_ID, pair: EClientErrors_UPDATE_TWS,
                tail: "  It does not support options exercise from the API.")
            return
        }
    
        if _serverVersion < MIN_SERVER_VER_TRADING_CLASS {
            if ((contract.tradingClass.isEmpty == false) || (contract.conId > 0)) {
                error(tickerId, pair: EClientErrors_UPDATE_TWS,
                    tail: "  It does not support conId and tradingClass parameters in exerciseOptions.")
                return
            }
        }
    
        send(EXERCISE_OPTIONS)
        send(VERSION)
        send(tickerId)
    
        // send contract fields
        if _serverVersion >= MIN_SERVER_VER_TRADING_CLASS {
            send(contract.conId)
        }
        send(contract.symbol)
        send(contract.secType)
        send(contract.expiry)
        send(contract.strike)
        send(contract.right)
        send(contract.multiplier)
        send(contract.exchange)
        send(contract.currency)
        send(contract.localSymbol)
        if _serverVersion >= MIN_SERVER_VER_TRADING_CLASS {
            send(contract.tradingClass)
        }
        send(exerciseAction)
        send(exerciseQuantity)
        send(account)
        send(override)
            // TODO: Handle errors here
        //catch (Exception e) {
        //error(tickerId, EClientErrors_FAIL_SEND_REQMKT, "" + e)
        //close()
        //}
    }
    
    func placeOrder(id: Int, contract: Contract, order: Order) { // synchronized
        // not connected?
        if !connected {
            notConnected()
            return
        }
    
        if _serverVersion < MIN_SERVER_VER_SCALE_ORDERS {
            if (order.scaleInitLevelSize != Int.max ||
                order.scalePriceIncrement != Double.NaN) {
                    error(id, pair: EClientErrors_UPDATE_TWS,
                        tail: "  It does not support Scale orders.")
                    return
            }
        }
    
        if _serverVersion < MIN_SERVER_VER_SSHORT_COMBO_LEGS {
            if contract.comboLegs.count > 0 {
                for i in 1...contract.comboLegs.count {
                    let comboLeg = contract.comboLegs[i]
                    if (comboLeg.shortSaleSlot != 0 ||
                        (comboLeg.designatedLocation.isEmpty == false)) {
                            error(id, pair: EClientErrors_UPDATE_TWS,
                                tail: "  It does not support SSHORT flag for combo legs.")
                            return
                    }
                }
            }
        }
    
        if _serverVersion < MIN_SERVER_VER_WHAT_IF_ORDERS {
            if (order.whatIf) {
                error(id, pair: EClientErrors_UPDATE_TWS,
                    tail: "  It does not support what-if orders.")
                return
            }
        }
        
        if _serverVersion < MIN_SERVER_VER_UNDER_COMP {
            if (contract.underComp != nil) {
                error(id, pair: EClientErrors_UPDATE_TWS,
                    tail: "  It does not support delta-neutral orders.")
                return
            }
        }
        
        if _serverVersion < MIN_SERVER_VER_SCALE_ORDERS2 {
            if (order.scaleSubsLevelSize != Int.max) {
                error(id, pair: EClientErrors_UPDATE_TWS,
                    tail: "  It does not support Subsequent Level Size for Scale orders.")
                return
            }
        }
        
        if _serverVersion < MIN_SERVER_VER_ALGO_ORDERS {
            if order.algoStrategy.isEmpty == false {
                error(id, pair: EClientErrors_UPDATE_TWS,
                    tail: "  It does not support algo orders.")
                return
            }
        }
        
        if _serverVersion < MIN_SERVER_VER_NOT_HELD {
            if (order.notHeld) {
                error(id, pair: EClientErrors_UPDATE_TWS,
                    tail: "  It does not support notHeld parameter.")
                return
            }
        }
        
        if _serverVersion < MIN_SERVER_VER_SEC_ID_TYPE {
            if (contract.secIdType.isEmpty == false) ||
                (contract.secId.isEmpty == false) {
                error(id, pair: EClientErrors_UPDATE_TWS,
                    tail: "  It does not support secIdType and secId parameters.")
                return
            }
        }
        
        if _serverVersion < MIN_SERVER_VER_PLACE_ORDER_CONID {
            if (contract.conId > 0) {
                error(id, pair: EClientErrors_UPDATE_TWS,
                    tail: "  It does not support conId parameter.")
                return
            }
        }
        
        if _serverVersion < MIN_SERVER_VER_SSHORTX {
            if (order.exemptCode != -1) {
                error(id, pair: EClientErrors_UPDATE_TWS,
                    tail: "  It does not support exemptCode parameter.")
                return
            }
        }
        
        if _serverVersion < MIN_SERVER_VER_SSHORTX {
            if contract.comboLegs.count > 0 {
                for i in 1...contract.comboLegs.count {
                    let comboLeg = contract.comboLegs[i]
                    if (comboLeg.exemptCode != -1) {
                        error(id, pair: EClientErrors_UPDATE_TWS,
                            tail: "  It does not support exemptCode parameter.")
                        return
                    }
                }
            }
        }
        
        if _serverVersion < MIN_SERVER_VER_HEDGE_ORDERS {
            if order.hedgeType.isEmpty == false {
                error(id, pair: EClientErrors_UPDATE_TWS,
                    tail: "  It does not support hedge orders.")
                return
            }
        }
        
        if _serverVersion < MIN_SERVER_VER_OPT_OUT_SMART_ROUTING {
            if (order.optOutSmartRouting) {
                error(id, pair: EClientErrors_UPDATE_TWS,
                    tail: "  It does not support optOutSmartRouting parameter.")
                return
            }
        }
        
        if _serverVersion < MIN_SERVER_VER_DELTA_NEUTRAL_CONID {
            if (order.deltaNeutralConId > 0
                || !order.deltaNeutralSettlingFirm.isEmpty
                || !order.deltaNeutralClearingAccount.isEmpty
                || !order.deltaNeutralClearingIntent.isEmpty
                ) {
                    error(id, pair: EClientErrors_UPDATE_TWS,
                        tail: "  It does not support deltaNeutral parameters: ConId, SettlingFirm, ClearingAccount, ClearingIntent")
                    return
            }
        }
        
        if _serverVersion < MIN_SERVER_VER_DELTA_NEUTRAL_OPEN_CLOSE {
            if (!order.deltaNeutralOpenClose.isEmpty
                || !order.deltaNeutralShortSale
                || order.deltaNeutralShortSaleSlot > 0
                || !order.deltaNeutralDesignatedLocation.isEmpty
                ) {
                    error(id, pair: EClientErrors_UPDATE_TWS,
                        tail: "  It does not support deltaNeutral parameters: OpenClose, ShortSale, ShortSaleSlot, DesignatedLocation")
                    return
            }
        }
        
        if _serverVersion < MIN_SERVER_VER_SCALE_ORDERS3 {
            if (order.scalePriceIncrement > 0 && order.scalePriceIncrement != Double.NaN) {
                if (order.scalePriceAdjustValue != Double.NaN ||
                    order.scalePriceAdjustInterval != Int.max ||
                    order.scaleProfitOffset != Double.NaN ||
                    order.scaleAutoReset ||
                    order.scaleInitPosition != Int.max ||
                    order.scaleInitFillQty != Int.max ||
                    order.scaleRandomPercent) {
                        error(id, pair: EClientErrors_UPDATE_TWS,
                            tail: "  It does not support Scale order parameters: PriceAdjustValue, PriceAdjustInterval, " +
                            "ProfitOffset, AutoReset, InitPosition, InitFillQty and RandomPercent")
                        return
                }
            }
        }
        
        if _serverVersion < MIN_SERVER_VER_ORDER_COMBO_LEGS_PRICE && caseInsensitiveEqual(BAG_SEC_TYPE, contract.secType) {
            if order.orderComboLegs.count > 0 {
                for i in 1...order.orderComboLegs.count {
                    let orderComboLeg = order.orderComboLegs[i]
                    if (orderComboLeg.price != Double.NaN) {
                        error(id, pair: EClientErrors_UPDATE_TWS,
                            tail: "  It does not support per-leg prices for order combo legs.")
                        return
                    }
                }
            }
        }
        
        if _serverVersion < MIN_SERVER_VER_TRAILING_PERCENT {
            if (order.trailingPercent != Double.NaN) {
                error(id, pair: EClientErrors_UPDATE_TWS,
                    tail: "  It does not support trailing percent parameter")
                return
            }
        }
        
        if _serverVersion < MIN_SERVER_VER_TRADING_CLASS {
            if (contract.tradingClass.isEmpty == false) {
                error(id, pair: EClientErrors_UPDATE_TWS,
                    tail: "  It does not support tradingClass parameters in placeOrder.")
                return
            }
        }
        
        if _serverVersion < MIN_SERVER_VER_SCALE_TABLE {
            if (order.scaleTable.isEmpty == false || order.activeStartTime.isEmpty == false || order.activeStopTime.isEmpty == false) {
                error(id, pair: EClientErrors_UPDATE_TWS,
                    tail: "  It does not support scaleTable, activeStartTime and activeStopTime parameters.")
                return
            }
        }
        
        let VERSION = (_serverVersion < MIN_SERVER_VER_NOT_HELD) ? 27 : 42
        
        // send place order msg
        send(PLACE_ORDER)
        send(VERSION)
        send(id)
        
        // send contract fields
        if (_serverVersion >= MIN_SERVER_VER_PLACE_ORDER_CONID) {
            send(contract.conId)
        }
        send(contract.symbol)
        send(contract.secType)
        send(contract.expiry)
        send(contract.strike)
        send(contract.right)
        if _serverVersion >= 15 {
            send(contract.multiplier)
        }
        send(contract.exchange)
        if (_serverVersion >= 14) {
            send(contract.primaryExch)
        }
        send(contract.currency)
        if (_serverVersion >= 2) {
            send (contract.localSymbol)
        }
        if _serverVersion >= MIN_SERVER_VER_TRADING_CLASS {
            send(contract.tradingClass)
        }
        if (_serverVersion >= MIN_SERVER_VER_SEC_ID_TYPE){
            send(contract.secIdType)
            send(contract.secId)
        }
        
        // send main order fields
        send(order.action)
        send(order.totalQuantity)
        send(order.orderType)
        if _serverVersion < MIN_SERVER_VER_ORDER_COMBO_LEGS_PRICE {
            send(order.lmtPrice == Double.NaN ? 0 : order.lmtPrice)
        }
        else {
            sendMax(order.lmtPrice)
        }
        if _serverVersion < MIN_SERVER_VER_TRAILING_PERCENT {
            send(order.auxPrice == Double.NaN ? 0 : order.auxPrice)
        }
        else {
            sendMax(order.auxPrice)
        }
        
        // send extended order fields
        send(order.tif)
        send(order.ocaGroup)
        send(order.account)
        send(order.openClose)
        send(order.origin)
        send(order.orderRef)
        send(order.transmit)
        if (_serverVersion >= 4 ) {
            send (order.parentId)
        }
        
        if (_serverVersion >= 5 ) {
            send (order.blockOrder)
            send (order.sweepToFill)
            send (order.displaySize)
            send (order.triggerMethod)
            if _serverVersion < 38 {
                // will never happen
                send(/* order.ignoreRth */ false)
            }
            else {
                send (order.outsideRth)
            }
        }
        
        if _serverVersion >= 7  {
            send(order.hidden)
        }
        
        // Send combo legs for BAG requests
        if _serverVersion >= 8 && caseInsensitiveEqual(BAG_SEC_TYPE, contract.secType) {
            send(contract.comboLegs.count)
            
            for i in 1...contract.comboLegs.count {
                let comboLeg = contract.comboLegs[i]
                send(comboLeg.conId)
                send(comboLeg.ratio)
                send(comboLeg.action)
                send(comboLeg.exchange)
                send(comboLeg.openClose)
                
                if _serverVersion >= MIN_SERVER_VER_SSHORT_COMBO_LEGS {
                    send(comboLeg.shortSaleSlot)
                    send(comboLeg.designatedLocation)
                }
                if _serverVersion >= MIN_SERVER_VER_SSHORTX_OLD {
                    send(comboLeg.exemptCode)
                }
            }
        }
        
        // Send order combo legs for BAG requests
        if _serverVersion >= MIN_SERVER_VER_ORDER_COMBO_LEGS_PRICE && caseInsensitiveEqual(BAG_SEC_TYPE, contract.secType) {
            send(order.orderComboLegs.count)
            
            for i in 1...order.orderComboLegs.count {
                let orderComboLeg = order.orderComboLegs[i]
                sendMax(orderComboLeg.price)
            }
        }
        
        if _serverVersion >= MIN_SERVER_VER_SMART_COMBO_ROUTING_PARAMS && caseInsensitiveEqual(BAG_SEC_TYPE, contract.secType) {
            let smartComboRoutingParams = order.smartComboRoutingParams
            let smartComboRoutingParamsCount = smartComboRoutingParams.count
            send(smartComboRoutingParamsCount)
            for i in 1...smartComboRoutingParamsCount {
                let tagValue = smartComboRoutingParams[i]
                send(tagValue.tag)
                send(tagValue.value)
            }
        }
        
        if ( _serverVersion >= 9 ) {
            // send deprecated sharesAllocation field
            send("")
        }
        
        if ( _serverVersion >= 10 ) {
            send(order.discretionaryAmt)
        }
        
        if ( _serverVersion >= 11 ) {
            send(order.goodAfterTime)
        }
        
        if ( _serverVersion >= 12 ) {
            send(order.goodTillDate)
        }
        
        if ( _serverVersion >= 13 ) {
            send(order.faGroup)
            send(order.faMethod)
            send(order.faPercentage)
            send(order.faProfile)
        }
        if _serverVersion >= 18 { // institutional short sale slot fields.
            send(order.shortSaleSlot)      // 0 only for retail, 1 or 2 only for institution.
            send(order.designatedLocation) // only populate when order.shortSaleSlot = 2.
        }
        if _serverVersion >= MIN_SERVER_VER_SSHORTX_OLD {
            send(order.exemptCode)
        }
        if _serverVersion >= 19 {
            send(order.ocaType)
            if _serverVersion < 38 {
                // will never happen
                send(/* order.rthOnly */ false)
            }
            send(order.rule80A)
            send(order.settlingFirm)
            send(order.allOrNone)
            sendMax(order.minQty)
            sendMax(order.percentOffset)
            send(order.eTradeOnly)
            send(order.firmQuoteOnly)
            sendMax(order.nbboPriceCap)
            sendMax(order.auctionStrategy)
            sendMax(order.startingPrice)
            sendMax(order.stockRefPrice)
            sendMax(order.delta)
            // Volatility orders had specific watermark price attribs in server version 26
            let lower = (_serverVersion == 26 && order.orderType == "VOL")
                ? Double.NaN
                : order.stockRangeLower
            let upper = (_serverVersion == 26 && order.orderType == "VOL")
                ? Double.NaN
                : order.stockRangeUpper
            sendMax(lower)
            sendMax(upper)
        }
        
        if _serverVersion >= 22 {
            send(order.overridePercentageConstraints)
        }
        
        if _serverVersion >= 26 { // Volatility orders
            sendMax(order.volatility)
            sendMax(order.volatilityType)
            if _serverVersion < 28 {
                send(caseInsensitiveEqual(order.deltaNeutralOrderType, "MKT"))
            } else {
                send(order.deltaNeutralOrderType)
                sendMax(order.deltaNeutralAuxPrice)
                
                if _serverVersion >= MIN_SERVER_VER_DELTA_NEUTRAL_CONID && order.deltaNeutralOrderType.isEmpty == false {
                    send(order.deltaNeutralConId)
                    send(order.deltaNeutralSettlingFirm)
                    send(order.deltaNeutralClearingAccount)
                    send(order.deltaNeutralClearingIntent)
                }
                
                if _serverVersion >= MIN_SERVER_VER_DELTA_NEUTRAL_OPEN_CLOSE && order.deltaNeutralOrderType.isEmpty == false {
                    send(order.deltaNeutralOpenClose)
                    send(order.deltaNeutralShortSale)
                    send(order.deltaNeutralShortSaleSlot)
                    send(order.deltaNeutralDesignatedLocation)
                }
            }
            send(order.continuousUpdate)
            if _serverVersion == 26 {
                // Volatility orders had specific watermark price attribs in server version 26
                let lower = order.orderType == "VOL" ? order.stockRangeLower : Double.NaN
                let upper = order.orderType == "VOL" ? order.stockRangeUpper : Double.NaN
                sendMax(lower)
                sendMax(upper)
            }
            sendMax(order.referencePriceType)
        }
        
        if _serverVersion >= 30 { // TRAIL_STOP_LIMIT stop price
            sendMax(order.trailStopPrice)
        }
        
        if (_serverVersion >= MIN_SERVER_VER_TRAILING_PERCENT){
            sendMax(order.trailingPercent)
        }
        
        if _serverVersion >= MIN_SERVER_VER_SCALE_ORDERS {
            if _serverVersion >= MIN_SERVER_VER_SCALE_ORDERS2 {
                sendMax (order.scaleInitLevelSize)
                sendMax (order.scaleSubsLevelSize)
            }
            else {
                send ("")
                sendMax (order.scaleInitLevelSize)
                
            }
            sendMax (order.scalePriceIncrement)
        }
        
        if _serverVersion >= MIN_SERVER_VER_SCALE_ORDERS3 && order.scalePriceIncrement > 0.0 && order.scalePriceIncrement == Double.NaN {
            sendMax (order.scalePriceAdjustValue)
            sendMax (order.scalePriceAdjustInterval)
            sendMax (order.scaleProfitOffset)
            send (order.scaleAutoReset)
            sendMax (order.scaleInitPosition)
            sendMax (order.scaleInitFillQty)
            send (order.scaleRandomPercent)
        }
        
        if _serverVersion >= MIN_SERVER_VER_SCALE_TABLE {
            send (order.scaleTable)
            send (order.activeStartTime)
            send (order.activeStopTime)
        }
        
        if _serverVersion >= MIN_SERVER_VER_HEDGE_ORDERS {
            send (order.hedgeType)
            if (order.hedgeType.isEmpty == false) {
                send (order.hedgeParam)
            }
        }
        
        if _serverVersion >= MIN_SERVER_VER_OPT_OUT_SMART_ROUTING {
            send (order.optOutSmartRouting)
        }
        
        if _serverVersion >= MIN_SERVER_VER_PTA_ORDERS {
            send (order.clearingAccount)
            send (order.clearingIntent)
        }
        
        if _serverVersion >= MIN_SERVER_VER_NOT_HELD {
            send (order.notHeld)
        }
        
        if _serverVersion >= MIN_SERVER_VER_UNDER_COMP {
            if let underComp = contract.underComp {
                send(true)
                send(underComp.conId)
                send(underComp.delta)
                send(underComp.price)
            }
            else {
                send(false)
            }
        }
        
        if _serverVersion >= MIN_SERVER_VER_ALGO_ORDERS {
            send(order.algoStrategy)
            if (order.algoStrategy.isEmpty == false) {
                let algoParams = order.algoParams
                let algoParamsCount = algoParams.count
                send(algoParamsCount)
                for i in 1...algoParamsCount {
                    let tagValue = algoParams[i]
                    send(tagValue.tag)
                    send(tagValue.value)
                }
            }
        }
        
        if _serverVersion >= MIN_SERVER_VER_WHAT_IF_ORDERS {
            send (order.whatIf)
        }
        
        // send orderMiscOptions parameter
        if _serverVersion >= MIN_SERVER_VER_LINKING {
            var orderMiscOptionsStr = ""
            let orderMiscOptions = order.orderMiscOptions
            let orderMiscOptionsCount = orderMiscOptions.count
            for i in 1...orderMiscOptionsCount {
                let tagValue = orderMiscOptions[i]
                orderMiscOptionsStr += tagValue.tag
                orderMiscOptionsStr += "="
                orderMiscOptionsStr += tagValue.value
                orderMiscOptionsStr += ";"
            }
            send(orderMiscOptionsStr)
        }

        // TODO: Handle errors here
        //catch( Exception e) {
        //error( id, EClientErrors_FAIL_SEND_ORDER, "" + e)
        //close()
        //}
    }
    
    func reqAccountUpdates(subscribe: Bool, acctCode: String) { // synchronized
        // not connected?
        if !connected {
            notConnected()
            return
        }
        
        let VERSION = 2
        
        // send cancel order msg
        send(REQ_ACCOUNT_DATA )
        send(VERSION)
        send(subscribe)
        
        // Send the account code. This will only be used for FA clients
        if ( _serverVersion >= 9 ) {
            send(acctCode)
        }
        //catch( Exception e) {
        //error( EClientErrors_NO_VALID_ID, EClientErrors_FAIL_SEND_ACCT, "" + e)
        //close()
        //}
    }
    
    func reqExecutions(reqId: Int, filter: ExecutionFilter) { // synchronized
        // not connected?
        if !connected {
            notConnected()
            return
        }
        
        let VERSION = 3
        
        // send cancel order msg
        send(REQ_EXECUTIONS)
        send(VERSION)
        
        if _serverVersion >= MIN_SERVER_VER_EXECUTION_DATA_CHAIN {
            send(reqId)
        }
        
        // Send the execution rpt filter data
        if ( _serverVersion >= 9 ) {
            send(filter.clientId)
            send(filter.acctCode)
            
            // Note that the valid format for m_time is "yyyymmdd-hh:mm:ss"
            send(filter.time)
            send(filter.symbol)
            send(filter.secType)
            send(filter.exchange)
            send(filter.side)
        }
        //catch( Exception e) {
        //error( EClientErrors_NO_VALID_ID, EClientErrors_FAIL_SEND_EXEC, "" + e)
        //close()
        //}
    }
    
    func cancelOrder(id: Int) { // synchronized
        // not connected?
        if !connected {
            notConnected()
            return
        }
    
        let VERSION = 1
    
        // send cancel order msg
        send(CANCEL_ORDER)
        send(VERSION)
        send(id)
        //catch( Exception e) {
        //error( id, EClientErrors_FAIL_SEND_CORDER, "" + e)
        //close()
        //}
    }
    
    func reqOpenOrders() { // synchronized
        // not connected?
        if !connected {
            notConnected()
            return
        }
    
        let VERSION = 1
    
        // send cancel order msg
        send(REQ_OPEN_ORDERS)
        send(VERSION)
        //catch( Exception e) {
        //error(EClientErrors_NO_VALID_ID, pair: EClientErrors_FAIL_SEND_OORDER, "" + e)
        //tail: close()
        //}
    }
    
    func reqIds(numIds: Int) { // synchronized
        // not connected?
        if !connected {
            notConnected()
            return
        }
    
        let VERSION = 1
    
        send(REQ_IDS)
        send(VERSION)
        send(numIds)
        //catch( Exception e) {
        //error( EClientErrors_NO_VALID_ID, EClientErrors_FAIL_SEND_CORDER, "" + e)
        //close()
        //}
    }
    
    func reqNewsBulletins(allMsgs: Bool) { // synchronized
        // not connected?
        if !connected {
            notConnected()
            return
        }
    
        let VERSION = 1
    
        send(REQ_NEWS_BULLETINS)
        send(VERSION)
        send(allMsgs)
        //catch( Exception e) {
        //error( EClientErrors_NO_VALID_ID, EClientErrors_FAIL_SEND_CORDER, "" + e)
        //close()
        //}
    }
    
    func cancelNewsBulletins() { // synchronized
        // not connected?
        if !connected {
            notConnected()
            return
        }
    
        let VERSION = 1
    
        // send cancel order msg
        send(CANCEL_NEWS_BULLETINS)
        send(VERSION)
        //catch( Exception e) {
        //error( EClientErrors_NO_VALID_ID, EClientErrors_FAIL_SEND_CORDER, "" + e)
        //close()
        //}
    }
    
    func setServerLogLevel(logLevel: Int) { // synchronized
        // not connected?
        if !connected {
            notConnected()
            return
        }
    
        let VERSION = 1
    
        // send the set server logging level message
        send(SET_SERVER_LOGLEVEL)
        send(VERSION)
        send(logLevel)
        //catch( Exception e) {
        //error( EClientErrors_NO_VALID_ID, EClientErrors_FAIL_SEND_SERVER_LOG_LEVEL, "" + e)
        //close()
        //}
    }
    
    func reqAutoOpenOrders(bAutoBind: Bool) { // synchronized
        // not connected?
        if !connected {
            notConnected()
            return
        }
    
        let VERSION = 1
    
        // send req open orders msg
        send(REQ_AUTO_OPEN_ORDERS)
        send(VERSION)
        send(bAutoBind)
        //catch( Exception e) {
        //error(EClientErrors_NO_VALID_ID, pair: EClientErrors_FAIL_SEND_OORDER, "" + e)
        //tail: close()
        //}
    }
    
    func reqAllOpenOrders() { // synchronized
        // not connected?
        if !connected {
            notConnected()
            return
        }
    
        let VERSION = 1
    
        // send req all open orders msg
        send(REQ_ALL_OPEN_ORDERS)
        send(VERSION)
        //catch( Exception e) {
        //error(EClientErrors_NO_VALID_ID, pair: EClientErrors_FAIL_SEND_OORDER, "" + e)
        //tail: close()
        //}
    }
    
    func reqManagedAccts() { // synchronized
        // not connected?
        if !connected {
            notConnected()
            return
        }
    
        let VERSION = 1
    
        // send req FA managed accounts msg
        send(REQ_MANAGED_ACCTS)
        send(VERSION)
        //catch( Exception e) {
        //error(EClientErrors_NO_VALID_ID, pair: EClientErrors_FAIL_SEND_OORDER, "" + e)
        //tail: close()
        //}
    }
    
    func requestFA(faDataType: Int) { // synchronized
        // not connected?
        if !connected {
            notConnected()
            return
        }
    
        // This feature is only available for versions of TWS >= 13
        if (_serverVersion < 13) {
            error(EClientErrors_NO_VALID_ID, errorCode: EClientErrors_UPDATE_TWS.code,
                errorMsg: EClientErrors_UPDATE_TWS.msg)
            return
        }
    
        let VERSION = 1
    
        send(REQ_FA )
        send(VERSION)
        send(faDataType)
        //catch( Exception e) {
        //error( faDataType, EClientErrors_FAIL_SEND_FA_REQUEST, "" + e)
        //close()
        //}
    }
    
    func replaceFA(faDataType: Int, xml: String) { // synchronized
        // not connected?
        if !connected {
            notConnected()
            return
        }
    
        // This feature is only available for versions of TWS >= 13
        if (_serverVersion < 13) {
            error(EClientErrors_NO_VALID_ID, errorCode: EClientErrors_UPDATE_TWS.code,
                errorMsg: EClientErrors_UPDATE_TWS.msg)
            return
        }
    
        let VERSION = 1
    
        send(REPLACE_FA )
        send(VERSION)
        send(faDataType)
        send(xml)
        //catch( Exception e) {
        //error( faDataType, EClientErrors_FAIL_SEND_FA_REPLACE, "" + e)
        //close()
        //}
    }
    
    func reqCurrentTime() { // synchronized
        // not connected?
        if !connected {
            notConnected()
            return
        }
    
        // This feature is only available for versions of TWS >= 33
        if (_serverVersion < 33) {
            error(EClientErrors_NO_VALID_ID, pair: EClientErrors_UPDATE_TWS,
                tail: "  It does not support current time requests.")
            return
        }
    
        let VERSION = 1
    
        send(REQ_CURRENT_TIME )
        send(VERSION)
        //catch( Exception e) {
        //error( EClientErrors_NO_VALID_ID, EClientErrors_FAIL_SEND_REQCURRTIME, "" + e)
        //close()
        //}
    }
    
    func reqFundamentalData(reqId: Int, contract: Contract, reportType: String) { // synchronized
        // not connected?
        if !connected {
            notConnected()
            return
        }
    
        if (_serverVersion < MIN_SERVER_VER_FUNDAMENTAL_DATA) {
            error( reqId, pair: EClientErrors_UPDATE_TWS,
                tail: "  It does not support fundamental data requests.")
            return
        }
    
        if (_serverVersion < MIN_SERVER_VER_TRADING_CLASS) {
            if( contract.conId > 0) {
                error(reqId, pair: EClientErrors_UPDATE_TWS,
                    tail: "  It does not support conId parameter in reqFundamentalData.")
                return
            }
        }
    
        let VERSION = 2
    
        // send req fund data msg
        send(REQ_FUNDAMENTAL_DATA)
        send(VERSION)
        send(reqId)
    
        // send contract fields
        if (_serverVersion >= MIN_SERVER_VER_TRADING_CLASS) {
            send(contract.conId)
        }
        send(contract.symbol)
        send(contract.secType)
        send(contract.exchange)
        send(contract.primaryExch)
        send(contract.currency)
        send(contract.localSymbol)
    
        send(reportType)
        //catch( Exception e) {
        //error( reqId, EClientErrors_FAIL_SEND_REQFUNDDATA, "" + e)
        //close()
        //}
    }
    
    func cancelFundamentalData(reqId: Int) { // synchronized
        // not connected?
        if !connected {
            notConnected()
            return
        }
    
        if (_serverVersion < MIN_SERVER_VER_FUNDAMENTAL_DATA) {
            error( reqId, pair: EClientErrors_UPDATE_TWS,
                tail: "  It does not support fundamental data requests.")
            return
        }
    
        let VERSION = 1
    
        // send req mkt data msg
        send(CANCEL_FUNDAMENTAL_DATA)
        send(VERSION)
        send(reqId)
        //catch( Exception e) {
        //error( reqId, EClientErrors_FAIL_SEND_CANFUNDDATA, "" + e)
        //close()
        //}
    }
    
    // synchronized
    func calculateImpliedVolatility(reqId: Int, contract: Contract,
        optionPrice: Double, underPrice: Double) {
            
            // not connected?
            if !connected {
                notConnected()
                return
            }
            
            if _serverVersion < MIN_SERVER_VER_REQ_CALC_IMPLIED_VOLAT {
                error(reqId, pair: EClientErrors_UPDATE_TWS,
                    tail: "  It does not support calculate implied volatility requests.")
                return
            }
            
            if _serverVersion < MIN_SERVER_VER_TRADING_CLASS {
                if contract.tradingClass.isEmpty == false {
                    error(reqId, pair: EClientErrors_UPDATE_TWS,
                        tail: "  It does not support tradingClass parameter in calculateImpliedVolatility.")
                    return
                }
            }
            
            let VERSION = 2
            
            // send calculate implied volatility msg
            send(REQ_CALC_IMPLIED_VOLAT)
            send(VERSION)
            send(reqId)
            
            // send contract fields
            send(contract.conId)
            send(contract.symbol)
            send(contract.secType)
            send(contract.expiry)
            send(contract.strike)
            send(contract.right)
            send(contract.multiplier)
            send(contract.exchange)
            send(contract.primaryExch)
            send(contract.currency)
            send(contract.localSymbol)
            if (_serverVersion >= MIN_SERVER_VER_TRADING_CLASS) {
                send(contract.tradingClass)
            }
            
            send(optionPrice)
            send(underPrice)
            //catch( Exception e) {
            //error( reqId, EClientErrors_FAIL_SEND_REQCALCIMPLIEDVOLAT, "" + e)
            //close()
            //}
    }
    
    // synchronized
    func cancelCalculateImpliedVolatility(reqId: Int) {
        
        // not connected?
        if !connected {
            notConnected()
            return
        }
        
        if _serverVersion < MIN_SERVER_VER_CANCEL_CALC_IMPLIED_VOLAT {
            error(reqId, pair: EClientErrors_UPDATE_TWS,
                tail: "  It does not support calculate implied volatility cancellation.")
            return
        }
        
        let VERSION = 1
        
        // send cancel calculate implied volatility msg
        send(CANCEL_CALC_IMPLIED_VOLAT)
        send(VERSION)
        send(reqId)
        //catch( Exception e) {
        //error( reqId, EClientErrors_FAIL_SEND_CANCALCIMPLIEDVOLAT, "" + e)
        //close()
        //}
    }
    
    // synchronized
    func calculateOptionPrice(reqId: Int, contract: Contract,
        volatility: Double, underPrice: Double) {
            
            // not connected?
            if !connected {
                notConnected()
                return
            }
            
            if _serverVersion < MIN_SERVER_VER_REQ_CALC_OPTION_PRICE {
                error(reqId, pair: EClientErrors_UPDATE_TWS,
                    tail: "  It does not support calculate option price requests.")
                return
            }
            
            if _serverVersion < MIN_SERVER_VER_TRADING_CLASS {
                if contract.tradingClass.isEmpty == false {
                    error(reqId, pair: EClientErrors_UPDATE_TWS,
                        tail: "  It does not support tradingClass parameter in calculateOptionPrice.")
                    return
                }
            }
            
            let VERSION = 2
            
            // send calculate option price msg
            send(REQ_CALC_OPTION_PRICE)
            send(VERSION)
            send(reqId)
            
            // send contract fields
            send(contract.conId)
            send(contract.symbol)
            send(contract.secType)
            send(contract.expiry)
            send(contract.strike)
            send(contract.right)
            send(contract.multiplier)
            send(contract.exchange)
            send(contract.primaryExch)
            send(contract.currency)
            send(contract.localSymbol)
            if (_serverVersion >= MIN_SERVER_VER_TRADING_CLASS) {
                send(contract.tradingClass)
            }
            
            send(volatility)
            send(underPrice)
            //catch( Exception e) {
            //error( reqId, EClientErrors_FAIL_SEND_REQCALCOPTIONPRICE, "" + e)
            //close()
            //}
    }
    
    // synchronized
    func cancelCalculateOptionPrice(reqId: Int) {
        
        // not connected?
        if !connected {
            notConnected()
            return
        }
        
        if _serverVersion < MIN_SERVER_VER_CANCEL_CALC_OPTION_PRICE {
            error(reqId, pair: EClientErrors_UPDATE_TWS,
                tail: "  It does not support calculate option price cancellation.")
            return
        }
        
        let VERSION = 1
        
        // send cancel calculate option price msg
        send(CANCEL_CALC_OPTION_PRICE)
        send(VERSION)
        send(reqId)
        //catch( Exception e) {
        //error( reqId, EClientErrors_FAIL_SEND_CANCALCOPTIONPRICE, "" + e)
        //close()
        //}
    }
    
    // synchronized
    func reqGlobalCancel() {
        // not connected?
        if !connected {
            notConnected()
            return
        }
        
        if _serverVersion < MIN_SERVER_VER_REQ_GLOBAL_CANCEL {
            error(EClientErrors_NO_VALID_ID, pair: EClientErrors_UPDATE_TWS,
                tail: "  It does not support globalCancel requests.")
            return
        }
        
        let VERSION = 1
        
        // send request global cancel msg
        send(REQ_GLOBAL_CANCEL)
        send(VERSION)
        //catch( Exception e) {
        //error( EClientErrors_NO_VALID_ID, EClientErrors_FAIL_SEND_REQGLOBALCANCEL, "" + e)
        //close()
        //}
    }
    
    // synchronized
    func reqMarketDataType(marketDataType: Int) {
        // not connected?
        if !connected {
            notConnected()
            return
        }
        
        if _serverVersion < MIN_SERVER_VER_REQ_MARKET_DATA_TYPE {
            error(EClientErrors_NO_VALID_ID, pair: EClientErrors_UPDATE_TWS,
                tail: "  It does not support marketDataType requests.")
            return
        }
        
        let VERSION = 1
        
        // send the reqMarketDataType message
        send(REQ_MARKET_DATA_TYPE)
        send(VERSION)
        send(marketDataType)
        //catch( Exception e) {
        //error( EClientErrors_NO_VALID_ID, EClientErrors_FAIL_SEND_REQMARKETDATATYPE, "" + e)
        //close()
        //}
    }
    
    // synchronized
    func reqPositions() {
        // not connected?
        if !connected {
            notConnected()
            return
        }
        
        if _serverVersion < MIN_SERVER_VER_ACCT_SUMMARY {
            error(EClientErrors_NO_VALID_ID, pair: EClientErrors_UPDATE_TWS,
                tail: "  It does not support position requests.")
            return
        }
        
        let VERSION = 1
        
        var b = Builder()
        b.send(REQ_POSITIONS)
        b.send(VERSION)
        
        let bgb = b.bytes
        dos?.write(bgb, maxLength: bgb.count)
        //catch (IOException e) {
        //error( EClientErrors_NO_VALID_ID, EClientErrors_FAIL_SEND_REQPOSITIONS, "" + e)
        //}
    }
    
    // synchronized
    func cancelPositions() {
        // not connected?
        if !connected {
            notConnected()
            return
        }
        
        if _serverVersion < MIN_SERVER_VER_ACCT_SUMMARY {
            error(EClientErrors_NO_VALID_ID, pair: EClientErrors_UPDATE_TWS,
                tail: "  It does not support position cancellation.")
            return
        }
        
        let VERSION = 1
        
        var b = Builder()
        b.send(CANCEL_POSITIONS)
        b.send(VERSION)
        
        let bgb = b.bytes
        dos?.write(bgb, maxLength: bgb.count)
        //catch (IOException e) {
        //error( EClientErrors_NO_VALID_ID, EClientErrors_FAIL_SEND_CANPOSITIONS, "" + e)
        //}
    }
    
    // synchronized
    func reqAccountSummary(reqId: Int, group: String, tags: String) {
        // not connected?
        if !connected {
            notConnected()
            return
        }
        
        if _serverVersion < MIN_SERVER_VER_ACCT_SUMMARY {
            error(EClientErrors_NO_VALID_ID, pair: EClientErrors_UPDATE_TWS,
                tail: "  It does not support account summary requests.")
            return
        }
        
        let VERSION = 1
        
        var b = Builder()
        b.send(REQ_ACCOUNT_SUMMARY)
        b.send(VERSION)
        b.send(reqId)
        b.send(group)
        b.send(tags)
        
        let bgb = b.bytes
        dos?.write(bgb, maxLength: bgb.count)
        //catch (IOException e) {
        //error( EClientErrors_NO_VALID_ID, EClientErrors_FAIL_SEND_REQACCOUNTDATA, "" + e)
        //}
    }
    
    // synchronized
    func cancelAccountSummary(reqId: Int) {
        // not connected?
        if !connected {
            notConnected()
            return
        }
        
        if _serverVersion < MIN_SERVER_VER_ACCT_SUMMARY {
            error(EClientErrors_NO_VALID_ID, pair: EClientErrors_UPDATE_TWS,
                tail: "  It does not support account summary cancellation.")
            return
        }
        
        let VERSION = 1
        
        var b = Builder()
        b.send(CANCEL_ACCOUNT_SUMMARY)
        b.send(VERSION)
        b.send(reqId)
        
        let bgb = b.bytes
        dos?.write(bgb, maxLength: bgb.count)
        //catch (IOException e) {
        //error( EClientErrors_NO_VALID_ID, EClientErrors_FAIL_SEND_CANACCOUNTDATA, "" + e)
        //}
    }
    
    // synchronized
    func verifyRequest(apiName: String, apiVersion: String) {
        // not connected?
        if !connected {
            notConnected()
            return
        }
        
        if _serverVersion < MIN_SERVER_VER_LINKING {
            error(EClientErrors_NO_VALID_ID, pair: EClientErrors_UPDATE_TWS,
                tail: "  It does not support verification request.")
            return
        }
        
        if (!extraAuth) {
            error( EClientErrors_NO_VALID_ID, pair: EClientErrors_FAIL_SEND_VERIFYMESSAGE,
                tail: "  Intent to authenticate needs to be expressed during initial connect request.")
            return
            
        }
        
        let VERSION = 1
        
        var b = Builder()
        b.send(VERIFY_REQUEST)
        b.send(VERSION)
        b.send(apiName)
        b.send(apiVersion)
        
        let bgb = b.bytes
        dos?.write(bgb, maxLength: bgb.count)
        //catch (IOException e) {
        //error( EClientErrors_NO_VALID_ID, EClientErrors_FAIL_SEND_VERIFYREQUEST, "" + e)
        //}
    }
    
    // synchronized
    func verifyMessage(apiData: String) {
        // not connected?
        if !connected {
            notConnected()
            return
        }
        
        if _serverVersion < MIN_SERVER_VER_LINKING {
            error(EClientErrors_NO_VALID_ID, pair: EClientErrors_UPDATE_TWS,
                tail: "  It does not support verification message sending.")
            return
        }
        
        let VERSION = 1
        
        var b = Builder()
        b.send(VERIFY_MESSAGE)
        b.send(VERSION)
        b.send(apiData)
        
        let bgb = b.bytes
        dos?.write(bgb, maxLength: bgb.count)
        //catch (IOException e) {
        //error( EClientErrors_NO_VALID_ID, EClientErrors_FAIL_SEND_VERIFYMESSAGE, "" + e)
        //}
    }
    
    // synchronized
    func queryDisplayGroups(reqId: Int) {
        // not connected?
        if !connected {
            notConnected()
            return
        }
        
        if _serverVersion < MIN_SERVER_VER_LINKING {
            error(EClientErrors_NO_VALID_ID, pair: EClientErrors_UPDATE_TWS,
                tail: "  It does not support queryDisplayGroups request.")
            return
        }
        
        let VERSION = 1
        
        var b = Builder()
        b.send(QUERY_DISPLAY_GROUPS)
        b.send(VERSION)
        b.send(reqId)
        
        let bgb = b.bytes
        dos?.write(bgb, maxLength: bgb.count)
        //catch (IOException e) {
        //error( EClientErrors_NO_VALID_ID, EClientErrors_FAIL_SEND_QUERYDISPLAYGROUPS, "" + e)
        //}
    }
    
    // synchronized
    func subscribeToGroupEvents(reqId: Int, groupId: Int) {
        // not connected?
        if !connected {
            notConnected()
            return
        }
        
        if _serverVersion < MIN_SERVER_VER_LINKING {
            error(EClientErrors_NO_VALID_ID, pair: EClientErrors_UPDATE_TWS,
                tail: "  It does not support subscribeToGroupEvents request.")
            return
        }
        
        let VERSION = 1
        
        var b = Builder()
        b.send(SUBSCRIBE_TO_GROUP_EVENTS)
        b.send(VERSION)
        b.send(reqId)
        b.send(groupId)
        
        let bgb = b.bytes
        dos?.write(bgb, maxLength: bgb.count)
        //catch (IOException e) {
        //error( EClientErrors_NO_VALID_ID, EClientErrors_FAIL_SEND_SUBSCRIBETOGROUPEVENTS, "" + e)
        //}
    }
    
    // synchronized
    func updateDisplayGroup(reqId: Int, contractInfo: String) {
        // not connected?
        if !connected {
            notConnected()
            return
        }
        
        if _serverVersion < MIN_SERVER_VER_LINKING {
            error(EClientErrors_NO_VALID_ID, pair: EClientErrors_UPDATE_TWS,
                tail: "  It does not support updateDisplayGroup request.")
            return
        }
        
        let VERSION = 1
        
        var b = Builder()
        b.send(UPDATE_DISPLAY_GROUP)
        b.send(VERSION)
        b.send(reqId)
        b.send(contractInfo)
        
        let bgb = b.bytes
        dos?.write(bgb, maxLength: bgb.count)
        //catch (IOException e) {
        //error( EClientErrors_NO_VALID_ID, EClientErrors_FAIL_SEND_UPDATEDISPLAYGROUP, "" + e)
        //}
    }
    
    // synchronized
    func unsubscribeFromGroupEvents(reqId: Int) {
        // not connected?
        if !connected {
            notConnected()
            return
        }
        
        if _serverVersion < MIN_SERVER_VER_LINKING {
            error(EClientErrors_NO_VALID_ID, pair: EClientErrors_UPDATE_TWS,
                tail: "  It does not support unsubscribeFromGroupEvents request.")
            return
        }
        
        let VERSION = 1
        
        var b = Builder()
        b.send(UNSUBSCRIBE_FROM_GROUP_EVENTS)
        b.send(VERSION)
        b.send(reqId)
        
        let bgb = b.bytes
        dos?.write(bgb, maxLength: bgb.count)
        //catch (IOException e) {
        //error( EClientErrors_NO_VALID_ID, EClientErrors_FAIL_SEND_UNSUBSCRIBEFROMGROUPEVENTS, "" + e)
        //}
    }
    
    func error(id: Int, errorCode: Int, errorMsg: String) { // synchronized
        _anyWrapper.error(id, errorCode: errorCode, errorMsg: errorMsg)
    }
    
    func close() {
        eDisconnect()
        eWrapper().connectionClosed()
    }
    
    func error(id: Int, pair: CodeMsgPair, tail: String) {
        error(id, errorCode: pair.code, errorMsg: pair.msg + tail)
    }
    
    func send(str: String) {
        // write string to data buffer; writer thread will
        // write it to socket
        if !str.isEmpty {
            // TODO: Add comprehensive error handling here
            if let dataBytes = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)? {
                var bytes = [Byte](count: dataBytes.length, repeatedValue: 0)
                dataBytes.getBytes(&bytes, length: dataBytes.length)
                dos?.write(bytes, maxLength: dataBytes.length)
            }
        }
        sendEOL()
    }
    
    func sendEOL() {
        dos?.write(EOL, maxLength: 1)
    }
    
    func send(val: Int) {
        send(itos(val))
    }
    
    func send(val: Character) {
        var s = String(val)
        send(s)
    }
    
    func send(val: Double) {
        send(dtos(val))
    }
    
    func send(val: Int64) {
        send(ltos(val))
    }
    
    func sendMax(val: Double) {
        if (val == Double.NaN) {
            sendEOL()
        }
        else {
            send(dtos(val))
        }
    }
    
    func sendMax(val: Int) {
        if (val == Int.max) {
            sendEOL()
        }
        else {
            send(itos(val))
        }
    }
    
    func send(val: Bool) {
        send( val ? 1 : 0)
    }
    
    func notConnected() {
        error(EClientErrors_NO_VALID_ID, pair: EClientErrors_NOT_CONNECTED, tail: "")
    }
}

// REMOVED METHOD

//    public synchronized void eConnect(Socket socket, int clientId) throws IOException {
//    m_clientId = clientId
//    eConnect(socket)
//    }
//
//    private static boolean IsEmpty(String str) {
//    return Util.StringIsEmpty(str)
//    }
//
//    private static boolean is( String str) {
//    // return true if the string is not empty
//    return str != null && str.length() > 0;
//    }
//
//    private static boolean isNull( String str) {
//    // return true if the string is null or empty
//    return !is( str)
//    }
//
//    /** @deprecated, never called. */
//    protected synchronized void error( String err) {
//    _anyWrapper.error( err)
//    }

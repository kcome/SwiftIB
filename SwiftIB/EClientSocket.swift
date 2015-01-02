//
//  EClientSocket.swift
//  SwiftIB
//
//  Created by Harry Li on 2/01/2015.
//  Copyright (c) 2015 Hanfei Li. All rights reserved.
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

class EClientSocket {
    
    let CLIENT_VERSION = 63
    let SERVER_VERSION = 38
    let EOL = [0]
    let BAG_SEC_TYPE = "BAG"
    
    let GROUPS = 1
    let PROFILES = 2
    let ALIASES = 3

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

    private var anyWrapper : AnyWrapper?    // msg handler
    //protected DataOutputStream m_dos   // the socket output stream
    private var connected : Bool = false        // true if we are connected
    //private EReader m_reader           // thread which reads msgs from socket
    private var _serverVersion : Int = 0
    private var TwsTime : String = ""
    private var clientId : Int = 0
    private var extraAuth : Bool = false
    
    func serverVersion() -> Int { return _serverVersion }
    func TwsConnectionTime() -> String { return TwsTime }
    func wrapper() -> AnyWrapper? { return anyWrapper }
    //public EReader reader()             { return m_reader }
    func isConnected() -> Bool { return connected }

    init() {
    }

}

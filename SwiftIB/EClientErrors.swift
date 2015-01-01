//
//  EClientErrors.swift
//  SwiftIB
//
//  Created by Hanfei Li on 1/01/2015.
//  Copyright (c) 2015 Hanfei Li. All rights reserved.
//

import Foundation

/* Copyright (C) 2013 Interactive Brokers LLC. All rights reserved.  This code is subject to the terms
* and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

struct CodeMsgPair {
    private var errorCode: Int
    private var errorMsg: String
    var code: Int {
        return errorCode
    }
    var msg: String {
        return errorMsg
    }
    init(code: Int, p_msg: String) {
        errorCode = code
        errorMsg = p_msg
    }
}

class EClientErrors {

    let NO_VALID_ID = -1
    let NOT_CONNECTED = CodeMsgPair(code: 504, p_msg: "Not connected")
    let UPDATE_TWS = CodeMsgPair(code: 503, p_msg: "The TWS is out of date and must be upgraded.")
    let ALREADY_CONNECTED = CodeMsgPair(code: 501, p_msg: "Already connected.")
    let CONNECT_FAIL = CodeMsgPair(code: 502, p_msg: "Couldn't connect to TWS.  Confirm that \"Enable ActiveX and Socket Clients\" is enabled on the TWS \"Configure->API\" menu.")
    let FAIL_SEND = CodeMsgPair(code: 509, p_msg: "Failed to send message - ") // generic message. all future messages should use this
    let UNKNOWN_ID = CodeMsgPair(code: 505, p_msg: "Fatal Error: Unknown message id.")
    let FAIL_SEND_REQMKT = CodeMsgPair(code: 510, p_msg: "Request Market Data Sending Error - ")
    let FAIL_SEND_CANMKT = CodeMsgPair(code: 511, p_msg: "Cancel Market Data Sending Error - ")
    let FAIL_SEND_ORDER = CodeMsgPair(code: 512, p_msg: "Order Sending Error - ")
    let FAIL_SEND_ACCT = CodeMsgPair(code: 513, p_msg: "Account Update Request Sending Error -")
    let FAIL_SEND_EXEC = CodeMsgPair(code: 514, p_msg: "Request For Executions Sending Error -")
    let FAIL_SEND_CORDER = CodeMsgPair(code: 515, p_msg: "Cancel Order Sending Error -")
    let FAIL_SEND_OORDER = CodeMsgPair(code: 516, p_msg: "Request Open Order Sending Error -")
    let UNKNOWN_CONTRACT = CodeMsgPair(code: 517, p_msg: "Unknown contract. Verify the contract details supplied.")
    let FAIL_SEND_REQCONTRACT = CodeMsgPair(code: 518, p_msg: "Request Contract Data Sending Error - ")
    let FAIL_SEND_REQMKTDEPTH = CodeMsgPair(code: 519, p_msg: "Request Market Depth Sending Error - ")
    let FAIL_SEND_CANMKTDEPTH = CodeMsgPair(code: 520, p_msg: "Cancel Market Depth Sending Error - ")
    let FAIL_SEND_SERVER_LOG_LEVEL = CodeMsgPair(code: 521, p_msg: "Set Server Log Level Sending Error - ")
    let FAIL_SEND_FA_REQUEST = CodeMsgPair(code: 522, p_msg: "FA Information Request Sending Error - ")
    let FAIL_SEND_FA_REPLACE = CodeMsgPair(code: 523, p_msg: "FA Information Replace Sending Error - ")
    let FAIL_SEND_REQSCANNER = CodeMsgPair(code: 524, p_msg: "Request Scanner Subscription Sending Error - ")
    let FAIL_SEND_CANSCANNER = CodeMsgPair(code: 525, p_msg: "Cancel Scanner Subscription Sending Error - ")
    let FAIL_SEND_REQSCANNERPARAMETERS = CodeMsgPair(code: 526, p_msg: "Request Scanner Parameter Sending Error - ")
    let FAIL_SEND_REQHISTDATA = CodeMsgPair(code: 527, p_msg: "Request Historical Data Sending Error - ")
    let FAIL_SEND_CANHISTDATA = CodeMsgPair(code: 528, p_msg: "Request Historical Data Sending Error - ")
    let FAIL_SEND_REQRTBARS = CodeMsgPair(code: 529, p_msg: "Request Real-time Bar Data Sending Error - ")
    let FAIL_SEND_CANRTBARS = CodeMsgPair(code: 530, p_msg: "Cancel Real-time Bar Data Sending Error - ")
    let FAIL_SEND_REQCURRTIME = CodeMsgPair(code: 531, p_msg: "Request Current Time Sending Error - ")
    let FAIL_SEND_REQFUNDDATA = CodeMsgPair(code: 532, p_msg: "Request Fundamental Data Sending Error - ")
    let FAIL_SEND_CANFUNDDATA = CodeMsgPair(code: 533, p_msg: "Cancel Fundamental Data Sending Error - ")
    let FAIL_SEND_REQCALCIMPLIEDVOLAT = CodeMsgPair(code: 534, p_msg: "Request Calculate Implied Volatility Sending Error - ")
    let FAIL_SEND_REQCALCOPTIONPRICE = CodeMsgPair(code: 535, p_msg: "Request Calculate Option Price Sending Error - ")
    let FAIL_SEND_CANCALCIMPLIEDVOLAT = CodeMsgPair(code: 536, p_msg: "Cancel Calculate Implied Volatility Sending Error - ")
    let FAIL_SEND_CANCALCOPTIONPRICE = CodeMsgPair(code: 537, p_msg: "Cancel Calculate Option Price Sending Error - ")
    let FAIL_SEND_REQGLOBALCANCEL = CodeMsgPair(code: 538, p_msg: "Request Global Cancel Sending Error - ")
    let FAIL_SEND_REQMARKETDATATYPE = CodeMsgPair(code: 539, p_msg: "Request Market Data Type Sending Error - ")
    let FAIL_SEND_REQPOSITIONS = CodeMsgPair(code: 540, p_msg: "Request Positions Sending Error - ")
    let FAIL_SEND_CANPOSITIONS = CodeMsgPair(code: 541, p_msg: "Cancel Positions Sending Error - ")
    let FAIL_SEND_REQACCOUNTDATA = CodeMsgPair(code: 542, p_msg: "Request Account Data Sending Error - ")
    let FAIL_SEND_CANACCOUNTDATA = CodeMsgPair(code: 543, p_msg: "Cancel Account Data Sending Error - ")
    let FAIL_SEND_VERIFYREQUEST = CodeMsgPair(code: 544, p_msg: "Verify Request Sending Error - ")
    let FAIL_SEND_VERIFYMESSAGE = CodeMsgPair(code: 545, p_msg: "Verify Message Sending Error - ")
    let FAIL_SEND_QUERYDISPLAYGROUPS = CodeMsgPair(code: 546, p_msg: "Query Display Groups Sending Error - ")
    let FAIL_SEND_SUBSCRIBETOGROUPEVENTS = CodeMsgPair(code: 547, p_msg: "Subscribe To Group Events Sending Error - ")
    let FAIL_SEND_UPDATEDISPLAYGROUP = CodeMsgPair(code: 548, p_msg: "Update Display Group Sending Error - ")
    let FAIL_SEND_UNSUBSCRIBEFROMGROUPEVENTS = CodeMsgPair(code: 549, p_msg: "Unsubscribe From Group Events Sending Error - ")
    let FAIL_SEND_STARTAPI = CodeMsgPair(code: 550, p_msg: "Start API Sending Error - ")

}

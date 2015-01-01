//
//  Execution.swift
//  SwiftIB
//
//  Created by Hanfei Li on 1/01/2015.
//  Copyright (c) 2015 Hanfei Li. All rights reserved.
//

import Foundation

class Execution: Equatable {
    
    var orderId: Int = 0
    var clientId: Int = 0
    var execId: String = ""
    var time: String = ""
    var acctNumber: String = ""
    var exchange: String = ""
    var side: String = ""
    var shares: Int = 0
    var price: Double = 0
    var permId: Int = 0
    var liquidation: Int = 0
    var cumQty: Int = 0
    var avgPrice: Double = 0
    var orderRef: String = ""
    var evRule: String = ""
    var evMultiplier: Double = 0

    init(p_orderId: Int, p_clientId: Int, p_execId: String, p_time: String,
        p_acctNumber: String, p_exchange: String, p_side: String, p_shares: Int,
        p_price: Double, p_permId: Int, p_liquidation: Int, p_cumQty: Int,
        p_avgPrice: Double, p_orderRef: String, p_evRule: String, p_evMultiplier: Double) {
            orderId = p_orderId
            clientId = p_clientId
            execId = p_execId
            time = p_time
            acctNumber = p_acctNumber
            exchange = p_exchange
            side = p_side
            shares = p_shares
            price = p_price
            permId = p_permId
            liquidation = p_liquidation
            cumQty = p_cumQty
            avgPrice = p_avgPrice
            orderRef = p_orderRef
            evRule = p_evRule
            evMultiplier = p_evMultiplier
    }
    
}

func == (lhs: Execution, rhs: Execution) -> Bool {
    var ret = false
    
    if ( lhs === rhs ) {
        ret = true
    }
    else {
        ret = lhs.execId == rhs.execId
    }
    return ret
}

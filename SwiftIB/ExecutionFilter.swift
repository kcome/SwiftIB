//
//  ExecutionFilter.swift
//  SwiftIB
//
//  Created by Hanfei Li on 1/01/2015.
//  Copyright (c) 2015 Hanfei Li. All rights reserved.
//

import Foundation

class ExecutionFilter: Equatable {

    var clientId: Int = 0 // zero means no filtering on this field
    var acctCode: String
    var time: String
    var symbol: String
    var secType: String
    var exchange: String
    var side: String
   
    init(p_clientId: Int,  p_acctCode: String,  p_time: String,
        p_symbol: String,  p_secType: String,  p_exchange: String,  p_side: String) {
            clientId = p_clientId
            acctCode = p_acctCode
            time = p_time
            symbol = p_symbol
            secType = p_secType
            exchange = p_exchange
            side = p_side
    }
    
}

func == (lhs: ExecutionFilter, rhs: ExecutionFilter) -> Bool {
    var ret = false
    
    if ( lhs === rhs ) {
        ret = true
    }
    else {
        
        ret = (lhs.clientId == rhs.clientId && caseInsensitiveEqual(lhs.acctCode, rhs.acctCode) &&
            caseInsensitiveEqual(lhs.time, rhs.time) &&
            caseInsensitiveEqual(lhs.symbol, rhs.symbol) &&
            caseInsensitiveEqual(lhs.secType, rhs.secType) &&
            caseInsensitiveEqual(lhs.exchange, rhs.exchange) &&
            caseInsensitiveEqual(lhs.side, rhs.side))

    }
    return ret
}

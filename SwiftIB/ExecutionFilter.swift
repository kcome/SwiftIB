//
//  ExecutionFilter.swift
//  SwiftIB
//
//  Created by Hanfei Li on 1/01/2015.
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

open class ExecutionFilter: Equatable {

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

public func == (lhs: ExecutionFilter, rhs: ExecutionFilter) -> Bool {
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

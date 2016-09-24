//
//  Contract.swift
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

open class Contract: Equatable {
    
    var conId: Int = 0
    var symbol: String = ""
    var secType: String = ""
    var expiry: String = ""
    var strike: Double = 0
    var right: String = ""
    var multiplier: String = ""
    var exchange: String = ""
    
    var currency: String = ""
    var localSymbol: String = ""
    var tradingClass: String = ""
    var primaryExch: String = "" // pick a non-aggregate (ie not the SMART exchange) exchange that the contract trades on.  DO NOT SET TO SMART.
    var includeExpired: Bool = false // can not be set to true for orders.
    
    var secIdType: String = "" // CUSIP:SEDOL:ISIN:RIC
    var secId: String = ""
    
    // COMBOS
    var comboLegsDescrip: String = "" // received in open order version 14 and up for all combos
    var comboLegs: [ComboLeg] = [ComboLeg]()
    
    // delta neutral
    var underComp: UnderComp? = nil
    
    // TODO: Originally this class is "Cloneable", should we consider NSCopying?
    /*
    var Object clone() throws CloneNotSupportedException {
        Contract retval = (Contract)super.clone():
        retval.m_comboLegs = (Vector<ComboLeg>)retval.m_comboLegs.clone():
        return retval:
    }
    */
    
    public init() {
    }
    
    public init(p_conId: Int, p_symbol: String, p_secType: String, p_expiry: String,
        p_strike: Double, p_right: String, p_multiplier: String, p_exchange: String,
        p_currency: String, p_localSymbol: String, p_tradingClass: String,
        p_comboLegs: [ComboLeg]?, p_primaryExch: String, p_includeExpired: Bool,
        p_secIdType: String, p_secId: String) {
            conId = p_conId
            symbol = p_symbol
            secType = p_secType
            expiry = p_expiry
            strike = p_strike
            right = p_right
            multiplier = p_multiplier
            exchange = p_exchange
            currency = p_currency
            includeExpired = p_includeExpired
            localSymbol = p_localSymbol
            tradingClass = p_tradingClass
            primaryExch = p_primaryExch
            secIdType = p_secIdType
            secId = p_secId
            comboLegsDescrip = ""
            if p_comboLegs != nil { comboLegs = p_comboLegs! }
    }
    
}

public func == (lhs: Contract, rhs: Contract) -> Bool {
    if (lhs === rhs) {
        return true
    }
    
    if (lhs.conId != rhs.conId) {
        return false
    }
    
    if (lhs.secType != rhs.secType) {
        return false
    }
    
    if (lhs.symbol != rhs.symbol ||
        lhs.exchange != rhs.exchange ||
        lhs.primaryExch != rhs.primaryExch ||
        lhs.currency != rhs.currency) {
            return false
    }
    
    if (lhs.secType != "BOND") {
        
        if (lhs.strike != rhs.strike) {
            return false
        }
        
        if (lhs.expiry != rhs.expiry ||
            lhs.right != rhs.right ||
            lhs.multiplier != rhs.multiplier ||
            lhs.localSymbol != rhs.localSymbol ||
            lhs.tradingClass != rhs.tradingClass) {
                return false
        }
    }
    
    if (lhs.secIdType != rhs.secIdType) {
        return false
    }
    
    if (lhs.secId != rhs.secId) {
        return false
    }
    
    // compare combo legs
    if (!arrayEqualUnordered(lhs.comboLegs, rhs.comboLegs)) {
        return false
    }
    
    if (lhs.underComp == nil || rhs.underComp == nil) {
        return false
    } else {
        if (lhs.underComp != rhs.underComp) {
            return false
        }
    }
    return true
}

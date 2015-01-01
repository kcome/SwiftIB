//
//  Contract.swift
//  SwiftIB
//
//  Created by Hanfei Li on 1/01/2015.
//  Copyright (c) 2015 Hanfei Li. All rights reserved.
//

import Foundation

class Contract: Equatable {
    
    var conId: Int = 0
    var symbol: String? = nil
    var secType: String? = nil
    var expiry: String? = nil
    var strike: Double = 0
    var right: String? = nil
    var multiplier: String? = nil
    var exchange: String? = nil
    
    var currency: String? = nil
    var localSymbol: String? = nil
    var tradingClass: String? = nil
    var primaryExch: String? = nil // pick a non-aggregate (ie not the SMART exchange) exchange that the contract trades on.  DO NOT SET TO SMART.
    var includeExpired: Bool = false // can not be set to true for orders.
    
    var secIdType: String? = nil // CUSIP:SEDOL:ISIN:RIC
    var secId: String? = nil
    
    // COMBOS
    var comboLegsDescrip: String? = nil // received in open order version 14 and up for all combos
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
    
    init() {
    }
    
    init(p_conId: Int, p_symbol: String, p_secType: String, p_expiry: String,
        p_strike: Double, p_right: String, p_multiplier: String, p_exchange: String,
        p_currency: String, p_localSymbol: String, p_tradingClass: String,
        p_comboLegs: [ComboLeg], p_primaryExch: String, p_includeExpired: Bool,
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
            comboLegs = p_comboLegs
            primaryExch = p_primaryExch
            secIdType = p_secIdType
            secId = p_secId
            comboLegsDescrip = ""
    }
    
}

func == (lhs: Contract, rhs: Contract) -> Bool {
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

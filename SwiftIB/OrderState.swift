//
//  OrderState.swift
//  SwiftIB
//
//  Created by Hanfei Li on 1/01/2015.
//  Copyright (c) 2015 Hanfei Li. All rights reserved.
//

import Foundation

class OrderState: Equatable {
    
    var status: String = ""
    
    var initMargin: String = ""
    var maintMargin: String = ""
    var equityWithLoan: String = ""
    
    var commission: Double = 0
    var minCommission: Double = 0
    var maxCommission: Double = 0
    var commissionCurrency: String = ""
    
    var warningText: String = ""

    init(p_status: String, p_initMargin: String, p_maintMargin: String,
        p_equityWithLoan: String, p_commission: Double, p_minCommission: Double,
        p_maxCommission: Double, p_commissionCurrency: String, p_warningText: String) {
            initMargin = p_initMargin
            maintMargin = p_maintMargin
            equityWithLoan = p_equityWithLoan
            commission = p_commission
            minCommission = p_minCommission
            maxCommission = p_maxCommission
            commissionCurrency = p_commissionCurrency
            warningText = p_warningText
    }
}

func == (lhs: OrderState, rhs: OrderState) -> Bool {
    return true
}

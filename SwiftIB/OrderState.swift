//
//  OrderState.swift
//  SwiftIB
//
//  Created by Hanfei Li on 1/01/2015.
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

import Foundation

open class OrderState: Equatable {
    
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

public func == (lhs: OrderState, rhs: OrderState) -> Bool {
    return true
}

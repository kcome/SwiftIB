//
//  OrderComboLeg.swift
//  SwiftIB
//
//  Created by Hanfei Li on 1/01/2015.
//  Copyright (c) 2015 Hanfei Li. All rights reserved.
//

import Foundation

class OrderComboLeg: Equatable {
    
    var price: Double = Double.NaN // price per leg
    
    init(p_price: Double) {
        price = p_price
    }
    
}

func == (lhs: OrderComboLeg, rhs: OrderComboLeg) -> Bool {
    if ( lhs === rhs ) {
        return true
    }
    
    if (lhs.price != rhs.price) {
        return false
    }
    
    return true
}

//
//  UnderComp.swift
//  SwiftIB
//
//  Created by Hanfei Li on 1/01/2015.
//  Copyright (c) 2015 Hanfei Li. All rights reserved.
//

import Foundation

class UnderComp: Equatable {
    
    var conId: Int = 0
    var delta: Double = 0
    var price: Double = 0
    
}

func == (lhs: UnderComp, rhs: UnderComp) -> Bool {
    if lhs === rhs {
        return true
    }
    
    if  lhs.conId != rhs.conId ||
        lhs.delta != rhs.delta ||
        lhs.price != rhs.price {
        return false
    }
    
    return true
}

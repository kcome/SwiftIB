//
//  ComissionReport.swift
//  SwiftIB
//
//  Created by Hanfei Li on 1/01/2015.
//  Copyright (c) 2015 Hanfei Li. All rights reserved.
//

import Foundation

class CommissionReport : Equatable {
    
    var execId: String?
    var commission: Double = 0
    var currency: String?
    var realizedPNL: Double = 0
    var yield: Double = 0
    var yieldRedemptionDate: Int = 0 // YYYYMMDD format
    
    init() {
        
    }
}

func == (lhs: CommissionReport, rhs: CommissionReport) -> Bool {
    var ret = false
    if lhs === rhs {
        ret = true
    }
    else {
        if lhs.execId != nil && rhs.execId != nil {
            ret = lhs.execId == rhs.execId
        }
    }
    return ret
}
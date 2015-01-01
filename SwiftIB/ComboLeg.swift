//
//  ComboLeg.swift
//  SwiftIB
//
//  Created by Hanfei Li on 1/01/2015.
//  Copyright (c) 2015 Hanfei Li. All rights reserved.
//

import Foundation

class ComboLeg: Equatable {
    
    let SAME = 0 	// open/close leg value is same as combo
    let OPEN = 1
    let CLOSE = 2
    let UNKNOWN = 3
    
    var conId: Int = 0
    var ratio: Int = 0
    var action: String = "" // BUY/SELL/SSHORT/SSHORTX
    var exchange: String = ""
    var openClose: Int = 0
    
    // for stock legs when doing short sale
    var shortSaleSlot: Int = 0 // 1 = clearing broker, 2 = third party
    var designatedLocation: String = ""
    var exemptCode: Int = -1
    
    init() {
    }

    init(p_conId: Int, p_ratio: Int, p_action: String, p_exchange: String,
        p_openClose: Int) {
    }

    init(p_conId: Int, p_ratio: Int, p_action: String, p_exchange: String,
        p_openClose: Int, p_shortSaleSlot: Int, p_designatedLocation: String) {
    }
    
    init(p_conId: Int, p_ratio: Int, p_action: String, p_exchange: String, p_openClose: Int, p_shortSaleSlot: Int, p_designatedLocation: String, p_exemptCode: Int) {
        conId = p_conId
        ratio = p_ratio
        action = p_action
        exchange = p_exchange
        openClose = p_openClose
        shortSaleSlot = p_shortSaleSlot
        designatedLocation = p_designatedLocation
        exemptCode = p_exemptCode
    }
}

func == (lhs: ComboLeg, rhs: ComboLeg) -> Bool {
    if lhs === rhs {
        return true
    }
    
    if (lhs.conId != rhs.conId ||
        lhs.ratio != rhs.ratio ||
        lhs.openClose != rhs.openClose ||
        lhs.shortSaleSlot != rhs.shortSaleSlot ||
        lhs.exemptCode != rhs.exemptCode) {
            return false
    }
    
    if (!caseInsensitiveEqual(lhs.action, rhs.action)  ||
        !caseInsensitiveEqual(lhs.designatedLocation, rhs.designatedLocation) ||
        !caseInsensitiveEqual(lhs.exchange, rhs.exchange)) {
            return false
    }
    return true
}

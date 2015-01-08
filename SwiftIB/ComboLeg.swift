//
//  ComboLeg.swift
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

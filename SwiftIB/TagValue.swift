//
//  TagValue.swift
//  SwiftIB
//
//  Created by Hanfei Li on 1/01/2015.
//  Copyright (c) 2015 Hanfei Li. All rights reserved.
//

import Foundation

class TagValue: Equatable {
    
    var tag: String = ""
    var value: String = ""
    
    init() {
    }
    
    init(p_tag: String, p_value: String) {
        tag = p_tag
        value = p_value
    }
}

func == (lhs: TagValue, rhs: TagValue) -> Bool {
    if lhs === rhs {
        return true
    }
    
    if(lhs.tag != rhs.tag ||
       lhs.value != rhs.value) {
        return false
    }
    
    return true
}

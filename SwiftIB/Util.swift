//
//  swift
//  SwiftIB
//
//  Created by Hanfei Li on 1/01/2015.
//  Copyright (c) 2015 Hanfei Li. All rights reserved.
//

import Foundation

func itos(i: Int) -> String {
    return String(format:"%d", i)
}

func ltos(i: Int64) -> String {
    return String(format:"%ld", i)
}

func dtos(d: Double) -> String {
    return String(format:"%f", d)
}

func caseInsensitiveEqual(lhs: String, rhs: String) -> Bool {
    return lhs.lowercaseString == rhs.lowercaseString
}

func arrayEqualUnordered<T: Equatable>(lhs: [T], rhs: [T]) -> Bool {
    if lhs.count != rhs.count {
        return false
    }
    if lhs.count == 0 {
        return true
    }
    
    var matchedRhsElems = [Bool](count: lhs.count, repeatedValue: false)
    
    for litem in lhs {
        var counter = 0
        for (index, ritem) in enumerate(rhs) {
            counter++
            if matchedRhsElems[index] {
                continue
            }
            if ritem == litem {
                matchedRhsElems[index] = true
                counter--
                break
            }
        }
        if counter == lhs.count {
            return false
        }
    }
    return false
}

//
//  swift
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

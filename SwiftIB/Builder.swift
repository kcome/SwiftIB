//
//  Builder.swift
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

class Builder : CustomStringConvertible {
    
    private let SEP: Character = "\0"
    
    private var stringBuffer: String = ""

    func send(a: Int) {
        send( a == Int.max ? "" : itos(a) )
    }
    
    func send(a: Double) {
        send( a == Double.NaN ? "" : dtos(a) )
    }

    func send(a: Bool) {
        send( a ? 1 : 0 )
    }

    func send(a: IApiEnum) {
        send( a.getApiString() )
    }
    
    func send(a: String) {
        stringBuffer += a
        stringBuffer.append(SEP)
    }
    
    var description : String {
        return stringBuffer
    }
    
    var bytes : [UInt8] {
        if let sbdata = stringBuffer.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            var bytes = [UInt8](count: sbdata.length, repeatedValue: 0)
            sbdata.getBytes(&bytes, length: sbdata.length)
            return bytes
        }
        return []
    }

}

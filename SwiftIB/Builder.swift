//
//  Builder.swift
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

class Builder : CustomStringConvertible {
    
    fileprivate let SEP: Character = "\0"
    
    fileprivate var stringBuffer: String = ""

    func send(_ a: Int) {
        send( a == Int.max ? "" : itos(a) )
    }
    
    func send(_ a: Double) {
        send( a == Double.nan ? "" : dtos(a) )
    }

    func send(_ a: Bool) {
        send( a ? 1 : 0 )
    }

    func send(_ a: IApiEnum) {
        send( a.getApiString() )
    }
    
    func send(_ a: String) {
        stringBuffer += a
        stringBuffer.append(SEP)
    }
    
    var description : String {
        return stringBuffer
    }
    
    var bytes : [UInt8] {
        if let sbdata = stringBuffer.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            var bytes = [UInt8](repeating: 0, count: sbdata.count)
            (sbdata as NSData).getBytes(&bytes, length: sbdata.count)
            return bytes
        }
        return []
    }

}

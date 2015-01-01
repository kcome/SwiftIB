//
//  Builder.swift
//  SwiftIB
//
//  Created by Hanfei Li on 1/01/2015.
//  Copyright (c) 2015 Hanfei Li. All rights reserved.
//

import Foundation

class Builder : Printable {
    
    private let SEP: Character = "\0"
    
    private var stringBuffer: String = ""

    func send(a: Int) {
        send( a == Int.max ? "" : String(format:"%d", a) )
    }
    
    func send(a: Double) {
        send( a == Double.NaN ? "" : String(format:"%f", a) )
    }

    func send(a: Bool) {
        send( a ? 1 : 0)
    }

    // FIXME: IApiEnum is not defined.
//    public void send( IApiEnum a) {
//        send( a.getApiString() )
//    }
    
    func send(a: String) {
        stringBuffer += a
        stringBuffer.append(SEP)
    }
    
    var description : String {
        return stringBuffer
    }
    
    var bytes : [Byte] {
        if let sbdata = stringBuffer.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)? {
            var bytes = [Byte](count: sbdata.length, repeatedValue: 0)
            sbdata.getBytes(&bytes, length: sbdata.length)
            return bytes
        }
        return []
    }

}

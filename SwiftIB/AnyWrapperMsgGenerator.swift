//
//  AnyWrapperMsgGenerator.swift
//  SwiftIB
//
//  Created by Hanfei Li on 1/01/2015.
//  Copyright (c) 2015 Hanfei Li. All rights reserved.
//

import Foundation

class AnyWrapperMsgGenerator {
    
    class func error(ex: NSException) -> String {
        return "Error - " + ex.description
    }
    
    class func error(str: String) -> String {
        return str
    }
    
    class func error(id: Int, errorCode: Int, errorMsg: String) -> String {
        var err: String = String(id)
        err += " | "
        err += String(errorCode)
        err += " | "
        err += errorMsg
        return err
    }
    
    class func connectionClosed() -> String {
        return "Connection Closed"
    }

}

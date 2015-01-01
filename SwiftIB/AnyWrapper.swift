//
//  AnyWrapper.swift
//  SwiftIB
//
//  Created by Hanfei Li on 1/01/2015.
//  Copyright (c) 2015 Hanfei Li. All rights reserved.
//

import Foundation

protocol AnyWrapper {
    func error( e: NSException)
    func error( str: String)
    func error( id: Int, errorCode: Int, errorMsg:String)
    func connectionClosed()
}

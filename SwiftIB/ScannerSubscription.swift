//
//  ScannerSubscription.swift
//  SwiftIB
//
//  Created by Hanfei Li on 1/01/2015.
//  Copyright (c) 2015 Hanfei Li. All rights reserved.
//

import Foundation

struct ScannerSubscription {
    let NO_ROW_NUMBER_SPECIFIED = -1
    
    var numberOfRows: Int = -1
    var instrument: String = ""
    var locationCode: String = ""
    var scanCode: String = ""
    var abovePrice: Double = Double.NaN
    var belowPrice: Double = Double.NaN
    var aboveVolume: Int = Int.max
    var averageOptionVolumeAbove: Int = Int.max
    var marketCapAbove: Double = Double.NaN
    var marketCapBelow: Double = Double.NaN
    var moodyRatingAbove: String = ""
    var moodyRatingBelow: String = ""
    var spRatingAbove: String = ""
    var spRatingBelow: String = ""
    var maturityDateAbove: String = ""
    var maturityDateBelow: String = ""
    var couponRateAbove: Double = Double.NaN
    var couponRateBelow: Double = Double.NaN
    var excludeConvertible: String = ""
    var scannerSettingPairs: String = ""
    var stockTypeFilter: String = ""
}

//
//  VibrationService.swift
//  MobileWars
//
//  Created by Evgeny Kireev on 12.11.17.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import UIKit
import AudioToolbox


class VibrationService: NSObject {
    
    public enum VibrationPattern {
        case singleShort
        case singleLong
        case doubleShortWithShortPause
        case doubleLongWithShortPause
    }
    
    public class func playVibration(withPattern: VibrationPattern) {
        
    }
}

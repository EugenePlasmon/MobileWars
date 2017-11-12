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
    
    public enum VibrationStyle {
        case light
        case heavy
    }
    
    public class func playVibration(withStyle style: VibrationStyle) {
        switch style {
        case .light:
            let impactStyle: UIImpactFeedbackStyle = .light
            let generator = UIImpactFeedbackGenerator(style: impactStyle)
            generator.impactOccurred()
        case .heavy:
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
}

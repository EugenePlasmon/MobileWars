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
            if #available(iOS 10.0, *) {
                playLightVibration()
            } else {
                playHeavyVibration()
            }
        case .heavy:
            playHeavyVibration()
        }
    }
    
    @available(iOS 10.0, *)
    private class func playLightVibration() {
        let impactStyle: UIImpactFeedbackStyle = .light
        let generator = UIImpactFeedbackGenerator(style: impactStyle)
        generator.impactOccurred()
    }
    
    private class func playHeavyVibration() {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}

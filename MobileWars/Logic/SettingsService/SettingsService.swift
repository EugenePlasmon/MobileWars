//
//  SettingsService.swift
//  MobileWars
//
//  Created by Evgeny Kireev on 12.11.17.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import UIKit


private let kVibrationOnEnemyIsOn = "kVibrationOnEnemyIsOn"
private let kVibrationOnCollisionIsOn = "kVibrationOnCollisionIsOn"
private let kSoundsIsOn = "kSoundsIsOn"


class SettingsService: NSObject {
    
    public class func setDefaultSettingsValuesIfNeeded() {
        let vibrationOnEnemyIsOn: Bool? = UserDefaults.standard.value(forKey: kVibrationOnEnemyIsOn) as? Bool
        
        if vibrationOnEnemyIsOn == nil {
            self.changeVibrationOnEnemyIsOn(true)
        }
        
        let vibrationOnCollisionIsOn: Bool? = UserDefaults.standard.value(forKey: kVibrationOnCollisionIsOn) as? Bool
        
        if vibrationOnCollisionIsOn == nil {
            self.changeVibrationOnCollisionIsOn(true)
        }
        
        let soundsIsOn: Bool? = UserDefaults.standard.value(forKey: kSoundsIsOn) as? Bool
        
        if soundsIsOn == nil {
            self.changeSoundsIsOn(true)
        }
    }
    
    public class func changeVibrationOnEnemyIsOn(_ isOn: Bool) {
        UserDefaults.standard.set(isOn, forKey: kVibrationOnEnemyIsOn)
    }
    
    public class func changeVibrationOnCollisionIsOn(_ isOn: Bool) {
        UserDefaults.standard.set(isOn, forKey: kVibrationOnCollisionIsOn)
    }
    
    public class func changeSoundsIsOn(_ isOn: Bool) {
        UserDefaults.standard.set(isOn, forKey: kSoundsIsOn)
    }
    
    public class func vibrationOnEnemyIsOn() -> Bool {
        return UserDefaults.standard.bool(forKey: kVibrationOnEnemyIsOn)
    }
    
    public class func vibrationOnCollisionIsOn() -> Bool {
        return UserDefaults.standard.bool(forKey: kVibrationOnCollisionIsOn)
    }
    
    public class func soundsIsOn() -> Bool {
        return UserDefaults.standard.bool(forKey: kSoundsIsOn)
    }
}

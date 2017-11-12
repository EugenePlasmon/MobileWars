//
//  SettingsVCInterface.swift
//  MobileWars
//
//  Created by Максим Бриштен on 12.11.2017.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import UIKit

protocol SettingsVCInput {
    
}

protocol SettingsVCOutput {
    
    func viewDidPressBackButton()
    
    func viewDidChangeVibrationOnEnemySwitcher(toValue: Bool)
    
    func viewDidChangeVibrationOnCollideSwitcher(toValue: Bool)
    
    func viewDidChangeSoundsSwitcher(toValue: Bool)
}

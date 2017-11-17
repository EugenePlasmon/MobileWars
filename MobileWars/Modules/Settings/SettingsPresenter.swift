//
//  SettingsPresenter.swift
//  MobileWars
//
//  Created by Максим Бриштен on 12.11.2017.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import UIKit

class SettingsPresenter: NSObject {

    unowned var userInterface: SettingsVC
    
    init(userInterface: SettingsVC) {
        self.userInterface = userInterface
    }
    
//MARK: - Private
    
    private func closeModule() {
        userInterface.dismiss(animated: true, completion: nil)
    }
    
}


//MARK: - SettingsVCOutput
extension SettingsPresenter: SettingsVCOutput {
    
    func viewDidPressBackButton() {
        closeModule()
    }
    
    func viewDidChangeVibrationOnEnemySwitcher(toValue: Bool) {
        SettingsService.changeVibrationOnEnemyIsOn(toValue)
    }
    
    func viewDidChangeVibrationOnCollideSwitcher(toValue: Bool) {
        SettingsService.changeVibrationOnCollisionIsOn(toValue)
    }
    
    func viewDidChangeSoundsSwitcher(toValue: Bool) {
        SettingsService.changeSoundsIsOn(toValue)
    }
}

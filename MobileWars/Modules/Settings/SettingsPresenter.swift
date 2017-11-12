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

extension SettingsPresenter: SettingsVCOutput {
    func viewDidPressBackButton() {
        closeModule()
    }
}

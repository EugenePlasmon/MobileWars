//
//  MainMenuPresenter.swift
//  MobileWars
//
//  Created by Evgeny Kireev on 11.11.17.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import UIKit


class MainMenuPresenter: NSObject {

    unowned var userInterface: MainMenuVC
    
    init(userInterface: MainMenuVC) {
        self.userInterface = userInterface
    }
}


extension MainMenuPresenter: MainMenuVCOutput {
    
    func didPressPlayButton() {
        let gameVC = GameVC.createModule()
        userInterface.present(gameVC, animated: true, completion: nil)
    }
}

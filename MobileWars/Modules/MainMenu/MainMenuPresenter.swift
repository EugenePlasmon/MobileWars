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
    
    func didPressPlayIOSTeamButton() {
        let gameVC = GameVC.createModule(withTeam: .ios)
        userInterface.present(gameVC, animated: true, completion: nil)
    }
    
    func didPressPlayAndroidTeamButton() {
        let gameVC = GameVC.createModule(withTeam: .android)
        userInterface.present(gameVC, animated: true, completion: nil)
    }
    
    func didPressRecordsButton() {
        let recordsVC = RecordsVC.createModule()
        userInterface.present(recordsVC, animated: true, completion: nil)
    }
}

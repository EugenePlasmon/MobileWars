//
//  GamePresenter.swift
//  MobileWars
//
//  Created by Evgeny Kireev on 11.11.17.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import UIKit


class GamePresenter: NSObject {
    
    unowned var userInterface: GameVC
    
    init(userInterface: GameVC) {
        self.userInterface = userInterface
    }
    
    //MARK: - Private
    
    private func closeModule() {
        userInterface.dismiss(animated: true, completion: nil)
    }
}


extension GamePresenter: GameVCOutput {
    
    func viewDidReady() {
        userInterface.drawEnemies()
    }
    
    func viewDidPressBackButton() {
        self.closeModule()
    }
}

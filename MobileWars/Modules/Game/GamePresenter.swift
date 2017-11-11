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
    
    private func addEnemyAtRandomPointAtTop() {
        let screenWidth = UIScreen.main.bounds.width
        let randomX = Int(arc4random()) % Int(screenWidth)
        let randomPointAtTop = CGPoint(x: randomX, y: 0)
        
        userInterface.addEnemy(at: randomPointAtTop)
    }
}


//MARK: - GameVCOutput
extension GamePresenter: GameVCOutput {
    
    func viewDidReady() {
        addEnemyAtRandomPointAtTop()
    }
    
    func viewDidPressBackButton() {
        closeModule()
    }
}

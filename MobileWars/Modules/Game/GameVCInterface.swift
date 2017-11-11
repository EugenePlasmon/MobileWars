//
//  GameVCInterface.swift
//  MobileWars
//
//  Created by Evgeny Kireev on 11.11.17.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import UIKit


protocol GameVCInput {
    
    func addEnemy(at point: CGPoint, withId id: String)
    
    func addDefender(at point: CGPoint, withId id: String)
    
    func addVelocity(_ velocity: CGPoint, forEnemyWithId id: String)
    
    func stopEnemy(withId id: String)
    
    func killEnemy(withId id: String)
    
    func dropDownEnemy(withId id: String)
    
    func removeEnemy(withId id: String, withFadeOut: Bool)
    
    func updateScoreLabel(withScore score: Int)
    
    func showComboLabel(withRate rate: Int)
    
    func hideComboLabel()
    
    func getGameViewFrame() -> CGRect
    
}


protocol GameVCOutput {
    
    func viewDidReady()
    
    func viewWillDissapear()
    
    func viewDidPressBackButton()
    
    func viewDidAddEnemy(withId id: String)
    
    func viewDidTouchDownEnemy(withId id: String)
    
    func viewDidTouchUpEnemy(withId id: String)
}

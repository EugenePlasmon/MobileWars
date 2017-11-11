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
}


protocol GameVCOutput {
    
    func viewDidReady()
    
    func viewWillDissapear()
    
    func viewDidPressBackButton()
}

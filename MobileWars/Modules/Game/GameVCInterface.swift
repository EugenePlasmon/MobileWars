//
//  GameVCInterface.swift
//  MobileWars
//
//  Created by Evgeny Kireev on 11.11.17.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import Foundation


protocol GameVCInput {
    
    func drawEnemies()
}


protocol GameVCOutput {
    
    func viewDidReady()
    
    func viewDidPressBackButton()
}

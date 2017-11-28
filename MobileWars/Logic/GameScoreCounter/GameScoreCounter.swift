//
//  GameScoreCounter.swift
//  MobileWars
//
//  Created by Максим Бриштен on 28.11.2017.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import Foundation


class GameScoreCounter {
    
    var gameComboCounter = GameComboCounter()

    var score = 0 {
        didSet {
            if score < 0 {
                score = 0
            }
        }
    }
    
    func calculateScore() {
        gameComboCounter.calculateCombo()
        score += gameComboCounter.currentComboMode.rawValue
    }
    
}

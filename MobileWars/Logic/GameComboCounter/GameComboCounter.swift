//
//  GameComboCounter.swift
//  MobileWars
//
//  Created by Максим Бриштен on 28.11.2017.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import Foundation


class GameComboCounter {
    
    var maxTimeIntervalForCombo = 5.0
    let touchesCountRequiredToNextCombo = 5
    
    var touchesInCurrentCombo = 0
    var currentComboMode: ComboMode = .noCombo
    var lastTouchTime: Date?
    
    enum ComboMode: Int {
        case noCombo = 1
        case x2 = 2
        case x3 = 3
        case x5 = 5
        case x10 = 10
    }
    
    func calculateCombo() {
        let now = Date()
        
        if lastTouchTime != nil {
            touchesInCurrentCombo += 1
            
            if touchesInCurrentCombo >= touchesCountRequiredToNextCombo && currentComboMode != .x10 {
                print("NEXT COMBO MODE!")
                setNextComboMode()
                touchesInCurrentCombo = 1
            }
        } else {
            touchesInCurrentCombo = 1
        }
        
        lastTouchTime = now
    }
    
    private func setNextComboMode() {
        switch currentComboMode {
        case .noCombo:
            currentComboMode = .x2
        case .x2:
            currentComboMode = .x3
        case .x3:
            currentComboMode = .x5
        case .x5:
            currentComboMode = .x10
        default:
            break
        }
    }
    
}

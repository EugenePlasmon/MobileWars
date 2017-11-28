//
//  EnemyVelocityUpdater.swift
//  MobileWars
//
//  Created by Максим Бриштен on 26.11.2017.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import Foundation
import UIKit


private let minXStartVelocity: CGFloat = -50.0
private let maxXStartVelocity: CGFloat = 50.0
private let minYStartVelocity: CGFloat = 100.0
private let maxYStartVelocity: CGFloat = 300.0
private let minXAdditionVelocity: CGFloat = -20.0
private let maxXAdditionVelocity: CGFloat = 20.0
private let minYAdditionVelocity: CGFloat = -20.0
private let maxYAdditionVelocity: CGFloat = 20.0


class EnemyVelocityUpdater {
    
    var randomStartVelocity = CGPoint.random(xMin: minXStartVelocity,
                                             xMax: maxXStartVelocity,
                                             yMin: minYStartVelocity,
                                             yMax: maxYStartVelocity)
    
    func calculateRandomVelocity(from velocity: CGPoint) -> CGPoint {
        var actualMinYAddition: CGFloat!
        var actualMaxYAddition: CGFloat!
        
        if velocity.y <= abs(minYAdditionVelocity) {
            actualMinYAddition = -velocity.y
        } else {
            actualMinYAddition = minYAdditionVelocity
        }
        
        if actualMinYAddition > maxYAdditionVelocity {
            actualMaxYAddition = actualMinYAddition
        } else {
            actualMaxYAddition = maxYAdditionVelocity
        }
        
        return CGPoint.random(xMin: minXAdditionVelocity,
                              xMax: maxXAdditionVelocity,
                              yMin: actualMinYAddition,
                              yMax: actualMaxYAddition)
    }
    
}

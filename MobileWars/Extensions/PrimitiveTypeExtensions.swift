//
//  PrimitiveTypeExtensions.swift
//  MobileWars
//
//  Created by Evgeny Kireev on 11.11.17.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import UIKit


extension Int {
    
    public static func random(from: Int,
                                to: Int) -> Int {
        assert(to >= from,
               "Invalid parameters: to must be greater than from")
        
        let diff = to - from
        
        let randomPart = diff > 0 ? Int(arc4random()) % diff
                                  : 0
        
        return 1 + from + randomPart
    }
}


extension Double {
    
    public static func random(from: Double,
                                to: Double) -> Double {
        assert(to >= from,
               "Invalid parameters: to must be greater than from")
        
        let diff = to - from
        let k = 100000.0
        
        let randomPart = diff > 0 ? Double(Int(arc4random()) % Int(diff * k)) / k
                                  : 0
        
        return from + randomPart
    }
}


extension CGFloat {
    
    public static func random(from: CGFloat,
                                to: CGFloat) -> CGFloat {
        assert(to >= from,
               "Invalid parameters: to must be greater than from")
        
        let diff = to - from
        let k: CGFloat = 100000.0
        
        let randomPart = diff > 0 ? CGFloat(Int(arc4random()) % Int(diff * k)) / k
                                  : 0
        
        return from + randomPart
    }
}


extension CGPoint {
    
    public static func random(xMin: CGFloat,
                              xMax: CGFloat,
                              yMin: CGFloat,
                              yMax: CGFloat) -> CGPoint {
        assert(xMax >= xMin,
               "Invalid parameters: to must be greater than from")
        assert(yMax >= yMin,
               "Invalid parameters: to must be greater than from")
        
        let randomX = CGFloat.random(from: xMin, to: xMax)
        let randomY = CGFloat.random(from: yMin, to: yMax)
        
        return CGPoint(x: randomX, y: randomY)
    }
    
    public func inverse() -> CGPoint {
        return CGPoint(x: -self.x, y: -self.y)
    }
}

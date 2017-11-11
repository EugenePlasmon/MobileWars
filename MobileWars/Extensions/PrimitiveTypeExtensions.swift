//
//  PrimitiveTypeExtensions.swift
//  MobileWars
//
//  Created by Evgeny Kireev on 11.11.17.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import Foundation


extension Int {
    
    public static func random(from: Int, to: Int) -> Int {
        assert(to > from,
               "Invalid parameters: to must be greater than from")
        
        let diff = to - from
        
        return 1 + from + Int(arc4random()) % diff
    }
}


extension Double {
    
    public static func random(from: Double, to: Double) -> Double {
        assert(to > from,
               "Invalid parameters: to must be greater than from")
        
        let diff = to - from
        let k = 100000.0
        
        return from + Double(Int(arc4random()) % Int(diff * k)) / k
    }
}

//
//  Record.swift
//  MobileWars
//
//  Created by Evgeny Kireev on 12.11.17.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import UIKit


public enum Team: Int {
    case ios = 1
    case android = 2
    
    public static func team(fromInt int: Int) -> Team? {
        switch int {
        case 1:
            return .ios
        case 2:
            return .android
        default:
            return nil
        }
    }
}


struct Record {
    
    let reachedScore: Int
    let date: Date
    let team: Team
    
    var description: String {
        return "Score: \(reachedScore), date: \(date), team: \(team)"
    }
}

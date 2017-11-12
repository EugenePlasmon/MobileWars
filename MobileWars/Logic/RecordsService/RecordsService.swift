//
//  RecordsService.swift
//  MobileWars
//
//  Created by Evgeny Kireev on 12.11.17.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import UIKit


private let maxRecordsCount = 10
private let cacheKey = "RecordsServiceCacheKey"
private let kScore = "kScore"
private let kDate = "kDate"
private let kTeam = "kTeam"


class RecordsService: NSObject {
    
    //MARK: - Public
    
    public class func saveRecordToCache(withScore score: Int, team: Team) {
        var cacheArray = UserDefaults.standard.object(forKey: cacheKey) as? [[String: Any]]
        
        if cacheArray == nil {
            cacheArray = []
        }
        
        if cacheArray!.count > maxRecordsCount {
            cacheArray?.removeLast()
        }
        
        var newRecordDict: [String: Any] = [:]
        newRecordDict[kScore] = NSNumber(value: score)
        newRecordDict[kDate] = NSDate()
        newRecordDict[kTeam] = NSNumber(value: team.rawValue)
        
        cacheArray!.insert(newRecordDict, at: 0)
        
        UserDefaults.standard.set(cacheArray, forKey: cacheKey)
    }
    
    public class func getRecordsFromCache() -> [Record] {
        let cacheArray = UserDefaults.standard.object(forKey: cacheKey) as? [[String: Any]]
        
        if cacheArray == nil {
            return []
        }
        
        return parseRecords(fromCacheArray: cacheArray!)
    }
    
    public class func clearCache() {
        UserDefaults.standard.removeObject(forKey: cacheKey)
    }
    
    //MARK: - Private
    
    private class func parseRecords(fromCacheArray cacheArray: [[String: Any]]) -> [Record] {
        var records: [Record] = []
        
        for recordDict in cacheArray {
            let record = parseRecord(fromDictionary: recordDict)
            records.append(record)
        }
        
        return records
    }
    
    private class func parseRecord(fromDictionary dict: [String: Any]) -> Record {
        let scoreNumber = dict[kScore] as! NSNumber
        let score = scoreNumber.intValue
        
        let date = (dict[kDate] as! NSDate) as Date
        
        let teamNumber = dict[kTeam] as! NSNumber
        let teamInt = teamNumber.intValue
        
        let team = Team.team(fromInt: teamInt)!
        
        let record = Record(reachedScore: score,
                                    date: date,
                                    team: team)
        
        return record
    }
}

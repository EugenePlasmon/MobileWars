//
//  GamePresenter.swift
//  MobileWars
//
//  Created by Evgeny Kireev on 11.11.17.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import UIKit


private let velocityUpdateTimeInterval = 0.1


public class GamePresenter: NSObject {
    
    unowned var userInterface: GameVC
    
    private var addingEnemiesTimer: Timer?
    private var movingEnemyTimers: [String: Timer] = [:]
    private var lastTouchTime: Date?
    private var score = 0
    private var touchesForComboCounter = 0
    private var touchesInCombo = 0
    private var comboRate = 0
    private var comboScore = 0
    
    init(userInterface: GameVC) {
        self.userInterface = userInterface
    }
    
    deinit {
        invalidateAllTimers()
    }
    
    //MARK: - Private
    
    private func closeModule() {
        userInterface.dismiss(animated: true, completion: nil)
    }
    
    private func startAddingEnemies() {
        addEnemyAtRandomPointAtTop()
        
        addingEnemiesTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                                        target: self,
                                                      selector: #selector(tickAddingEnemiesTimer),
                                                      userInfo: nil,
                                                       repeats: true)
    }
    
    private func stopAddingEnemies() {
        addingEnemiesTimer?.invalidate()
        addingEnemiesTimer = nil
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    @objc private func addEnemyAtRandomPointAtTop() {
        let screenWidth = UIScreen.main.bounds.width
        let randomX = Int.random(from: 0, to: Int(screenWidth))
        let randomPointAtTop = CGPoint(x: randomX, y: 0)
        
        let id = UUID().uuidString
        
        userInterface.addEnemy(at: randomPointAtTop, withId: id)
    }
    
    private func startMovingEnemy(withId id: String) {
        let randomStartVelocity = CGPoint.random(xMin: -50, xMax: 50,
                                                 yMin: 100, yMax: 300)
        self.userInterface.addVelocity(randomStartVelocity, forEnemyWithId: id)
        
        let newMovingTimer = Timer.scheduledTimer(withTimeInterval: velocityUpdateTimeInterval, repeats: true) { [weak self] (timer) in
            let randomVelocity = CGPoint.random(xMin: -50, xMax: 50,
                                                yMin: -50, yMax: 50)
            self?.userInterface.addVelocity(randomVelocity, forEnemyWithId: id)
        }
        
        movingEnemyTimers[id] = newMovingTimer
    }
    
    //Методы для SCORE
    private func makeArrayFromComboCounter(comboCounter: Int) -> [Int] {
        let comboCounterString = String(comboCounter)
        let array = comboCounterString.flatMap{Int(String($0))}
        
        return array
    }
    
    private func getComboRateToReturn(array: [Int]) -> Int {
        var newArray = array
        var comboRate = 0
        
        if array.count == 1 {
            comboRate = 1
        } else {
            newArray.removeLast()
            newArray[0] += 1
            var myString = ""
            _ = newArray.map{ myString = myString + "\($0)" }
            comboRate = Int(myString)!
        }
        
        return comboRate
    }
    
    func comboScore(touches: Int, rate: Int) -> Int {
        return touches * rate
    }
    
    private func comboScoreCounting(lastTouchTime: Double) {
        guard lastTouchTime <= 5 else {
            print("COMBO SCORE = \(comboScore)")
            score += comboScore
            userInterface.updateScoreLabel(withScore: score)
            userInterface.hideComboLabel()
            touchesForComboCounter = 0
            touchesInCombo = 0
            comboScore = 0
            return
        }
        
        touchesForComboCounter += 1
        
        if touchesForComboCounter > 10 {
            print("COMBO!")
            score -= 1
            touchesInCombo += 1
            let array = makeArrayFromComboCounter(comboCounter: touchesForComboCounter)
            comboRate = getComboRateToReturn(array: array)
            userInterface.showComboLabel(withRate: comboRate)
            comboScore = comboScore(touches: touchesInCombo, rate: comboRate)
            print("Touches in Combo-Mode: \(touchesInCombo) | Combo rate: \(comboRate)")
        }
    }
    
    // MARK: - Timer
    
    @objc private func tickAddingEnemiesTimer() {
        let maxDelay = 2.0
        let randomDelay = Double.random(from: 0.0, to: maxDelay)
        
        perform(#selector(addEnemyAtRandomPointAtTop), with: nil,
                                                 afterDelay: randomDelay)
    }
    
    private func invalidateAllTimers() {
        addingEnemiesTimer?.invalidate()
        addingEnemiesTimer = nil
        
        for timer in movingEnemyTimers.values {
            timer.invalidate()
        }
        
        movingEnemyTimers = [:]
    }
}


//MARK: - GameVCOutput
extension GamePresenter: GameVCOutput {
    
    func viewDidReady() {
        score = 0 // Обнуляем счет при новой игровой "сессии"
        startAddingEnemies()
    }
    
    func viewWillDissapear() {
        stopAddingEnemies()
    }
    
    func viewDidPressBackButton() {
        closeModule()
    }
    
    func viewDidAddEnemy(withId id: String) {
        startMovingEnemy(withId: id)
    }
    
    func viewDidTouchDownEnemy(withId id: String) {
        let now = Date()
        if let lastTouchTime = lastTouchTime {
            let timeSinceLast = now.timeIntervalSince(lastTouchTime)
            comboScoreCounting(lastTouchTime: timeSinceLast)
        }
        
        lastTouchTime = now
        
        movingEnemyTimers[id]?.invalidate()
        movingEnemyTimers[id] = nil
        
        userInterface.stopEnemy(withId: id)
        userInterface.killEnemy(withId: id)
    }
    
    func viewDidTouchUpEnemy(withId id: String) {
        userInterface.dropDownEnemy(withId: id)
        
        let waitTime = 0.5
        
        //FIXME: retain self
        DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {
            self.userInterface.removeEnemy(withId: id, withFadeOut: true)
        }
    }
    
    func viewAddScore() {
        score += 1
        userInterface.updateScoreLabel(withScore: score)
    }
}

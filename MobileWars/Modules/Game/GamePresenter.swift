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
    
    // MARK: - Timer
    
    @objc private func tickAddingEnemiesTimer() {
        let maxDelay = 2.0
        let randomDelay = Double.random(from: 0.0, to: maxDelay)
        
        perform(#selector(addEnemyAtRandomPointAtTop), with: nil,
                                                 afterDelay: randomDelay)
    }
    
    private func invalidateAllTimers() {
        addingEnemiesTimer?.invalidate()
        
        for timer in movingEnemyTimers.values {
            timer.invalidate()
        }
    }
}


//MARK: - GameVCOutput
extension GamePresenter: GameVCOutput {
    
    func viewDidReady() {
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
}

//
//  GamePresenter.swift
//  MobileWars
//
//  Created by Evgeny Kireev on 11.11.17.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import UIKit


private let velocityUpdateTimeInterval = 0.1
private let maxTimeIntervalForCombo = 5.0
private let touchesCountRequiredToNextCombo = 5
private let defendersCount = 3


public class GamePresenter: NSObject {
    
    enum ComboMode: Int {
        case noCombo = 1
        case x2 = 2
        case x3 = 3
        case x5 = 5
        case x10 = 10
    }
    
    unowned var userInterface: GameVC
    
    private var addingEnemiesTimer: Timer?
    private var movingEnemyTimers: [String: Timer] = [:]
    private var timerForNextTouchInCombo: Timer?
    private var lastTouchTime: Date?
    private var score = 0
    private var touchesInCurrentCombo = 0
    private var currentComboMode: ComboMode = .noCombo
    
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
    
    private func addDefenders() {
        let gameViewFrame = userInterface.getGameViewFrame()
        let gameViewWidth = gameViewFrame.width
        let gameViewHeight = gameViewFrame.height
        
        let bottomInset: CGFloat = 12.0
        let defenderSize = DefenderLogoView.size()
        let defenderHeight = defenderSize.height
        let defenderWidth = defenderSize.width
        
        let coordY = gameViewHeight - 0.5 * defenderHeight - bottomInset
        
        let defendersSumWidth = CGFloat(defendersCount) * defenderWidth
        let edgeInset: CGFloat = 80.0
        let defendersStackWidth = gameViewWidth - 2 * edgeInset
        let spaceBetweenDefenders = (defendersStackWidth - defendersSumWidth) / CGFloat(defendersCount - 1)
        
        let coordXForFirstDefender = edgeInset + 0.5 * defenderWidth
        
        for i in 0..<defendersCount {
            let coordXForCurrentDefender = coordXForFirstDefender + CGFloat(i) * (defenderWidth + spaceBetweenDefenders)
            let randomPointAtBottom = CGPoint(x: coordXForCurrentDefender, y: coordY)
            
            let id = UUID().uuidString
            
            userInterface.addDefender(at: randomPointAtBottom, withId: id)
        }
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
    
    //MARK: - Score counting
    
    private func calculateCombo() {
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
    
    private func calculateScore() {
        calculateCombo()
        score += currentComboMode.rawValue
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
    
    // MARK: - Timers
    
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
    
    private func startTimerForNextTouchInCombo() {
        timerForNextTouchInCombo?.invalidate()
        
        timerForNextTouchInCombo = Timer.scheduledTimer(timeInterval: maxTimeIntervalForCombo,
                                                              target: self,
                                                            selector: #selector(timerForNextTouchInComboExpired),
                                                            userInfo: nil,
                                                             repeats: false)
    }
    
    @objc private func timerForNextTouchInComboExpired() {
        //TODO: mb show label combo expired?
        
        currentComboMode = .noCombo
        touchesInCurrentCombo = 0
        
        userInterface.hideComboLabel()
    }
}


//MARK: - GameVCOutput
extension GamePresenter: GameVCOutput {
    
    func viewDidReady() {
        score = 0 // Обнуляем счет при новой игровой "сессии"
        startAddingEnemies()
        addDefenders()
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
        startTimerForNextTouchInCombo()
        calculateScore()
        userInterface.updateScoreLabel(withScore: score)
        
        if currentComboMode != .noCombo {
            userInterface.showComboLabel(withRate: currentComboMode.rawValue)
        } else {
            userInterface.hideComboLabel()
        }
        
        let now = Date()
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
    
    func viewDidCollide(enemyWithId enemyId: String, andDefenderWithId defenderId: String) {
        movingEnemyTimers[enemyId]?.invalidate()
        movingEnemyTimers[enemyId] = nil

        userInterface.removeEnemyWithExplosion(withId: enemyId)
        userInterface.removeDefender(withId: defenderId)
    }
}

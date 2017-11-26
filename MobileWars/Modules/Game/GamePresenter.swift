//
//  GamePresenter.swift
//  MobileWars
//
//  Created by Evgeny Kireev on 11.11.17.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import UIKit


private let velocityUpdateTimeInterval = 0.05
private let maxTimeIntervalForCombo = 5.0
private let touchesCountRequiredToNextCombo = 5
private let defendersCount = 3


private let scoreDecreaseAfterCollideWithDefender = 10

public class GamePresenter: NSObject {
    
    enum ComboMode: Int {
        case noCombo = 1
        case x2 = 2
        case x3 = 3
        case x5 = 5
        case x10 = 10
    }
    
    unowned var userInterface: GameVC
    public var team: Team
    
    private var addingEnemiesTimer: Timer?
    private var movingEnemyTimers: [String: Timer] = [:]
    private var timerForNextTouchInCombo: Timer?
    private var lastTouchTime: Date?
    private var score = 0 {
        didSet {
            if score < 0 {
                score = 0
            }
        }
    }
    private var touchesInCurrentCombo = 0
    private var currentComboMode: ComboMode = .noCombo
    private var defendersAliveCount = defendersCount
    
    init(userInterface: GameVC, team: Team) {
        self.userInterface = userInterface
        self.team = team
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
            
            userInterface.addDefender(at: randomPointAtBottom, withId: id, ofTeam: team)
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
        
        userInterface.addEnemy(at: randomPointAtTop, withId: id, ofTeam: team)
    }
    
    private func startMovingEnemy(withId id: String) {
        let randomStartVelocity = EnemyVelocityUpdater.randomStartVelocity
        
        self.userInterface.addVelocity(randomStartVelocity, forEnemyWithId: id)
        
        let newMovingTimer = Timer.scheduledTimer(withTimeInterval: velocityUpdateTimeInterval, repeats: true) { [weak self] (timer) in
            if self == nil {return}
            
            let currentVelocity = (self?.userInterface.getVelocityOfEnemy(withId: id))!
            let randomVelocity = EnemyVelocityUpdater.calculateRandomVelocity(from: currentVelocity)
            
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
        
        timerForNextTouchInCombo?.invalidate()
        timerForNextTouchInCombo = nil
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
        
        userInterface.hideComboLabel(withFadeOut: true)
    }
}


//MARK: - GameVCOutput
extension GamePresenter: GameVCOutput {
    
    func viewDidReady() {
        score = 0 // Обнуляем счет при новой игровой "сессии"
        userInterface.hideComboLabel(withFadeOut: false)
        startAddingEnemies()
        addDefenders()
    }
    
    func viewWillDissapear() {
        stopAddingEnemies()
        invalidateAllTimers()
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
        userInterface.showAdditionScoreLabel(atEnemyWithId: id, score: currentComboMode.rawValue)
        
        if SettingsService.vibrationOnEnemyIsOn() {
            VibrationService.playVibration(withStyle: .light)
        }
        
        if SettingsService.soundsIsOn() {
            PlayerService.playSound(ofType: .hit)
        }

        if currentComboMode != .noCombo {
            userInterface.showComboLabel(withRate: currentComboMode.rawValue)
        } else {
            userInterface.hideComboLabel(withFadeOut: true)
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
        
        if SettingsService.vibrationOnCollisionIsOn() {
            VibrationService.playVibration(withStyle: .heavy)
        }
        
        if SettingsService.soundsIsOn() {
            PlayerService.playSound(ofType: .explosion)
        }
        
        score -= scoreDecreaseAfterCollideWithDefender
        currentComboMode = .noCombo
        userInterface.hideComboLabel(withFadeOut: true)
        touchesInCurrentCombo = 0
        userInterface.updateScoreLabel(withScore: score)
        
        defendersAliveCount -= 1
        
        if defendersAliveCount == 0 {
            //game over
            RecordsService.saveRecordToCache(withScore: score,
                                                  team: team)
            
            let title = "Game over!"
            let message = "You reached \(score) scores"
            let okTitle = "OK"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let actionOk = UIAlertAction(title: okTitle, style: .cancel, handler: { (action) in
                self.closeModule()
            })
            
            ac.addAction(actionOk)
            
            userInterface.present(ac, animated: true, completion: nil)
        }
    }
    
    func viewDidTouchOnBG() {
        guard currentComboMode != .noCombo else { return }
        
        currentComboMode = .noCombo
        userInterface.hideComboLabel(withFadeOut: true)
        touchesInCurrentCombo = 0
        print("RESET COMBO")
    }
    
}

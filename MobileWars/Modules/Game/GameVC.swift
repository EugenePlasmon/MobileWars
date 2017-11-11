//
//  GameVC.swift
//  MobileWars
//
//  Created by Evgeny Kireev on 11.11.17.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import UIKit


class GameVC: UIViewController {
    
    var output: GameVCOutput!
    var enemies: [String: EnemyLogoView] = [:]
    var enemiesMoveBehaviours: [String: UIDynamicItemBehavior] = [:]
    
    lazy var animator: UIDynamicAnimator = {
        UIDynamicAnimator(referenceView: self.gameSceneView)
    }()
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var gameSceneView: UIView!
    
    //MARK: - Init
    
    class func createModule() -> GameVC {
        let nib = UINib(nibName: "GameVC", bundle: nil)
        let vc = nib.instantiate(withOwner: self,
                                 options: [:]).first as! GameVC
        vc.output = GamePresenter(userInterface: vc)
        
        return vc
    }
    
    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        output.viewDidReady()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        output.viewWillDissapear()
    }
    
    //MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        output.viewDidPressBackButton()
    }
}


//MARK: - GameVCInput
extension GameVC: GameVCInput {
    
    func addEnemy(at point: CGPoint, withId id: String) {
        let enemyLogoView = EnemyLogoView.createView()
        enemyLogoView.output = self
        enemyLogoView.enemyId = id
        enemyLogoView.center = point
        
        gameSceneView.addSubview(enemyLogoView)
        
        let behavior = UIDynamicItemBehavior()
        behavior.resistance = 0
        behavior.addItem(enemyLogoView)
        animator.addBehavior(behavior)
        
        enemies[id] = enemyLogoView
        enemiesMoveBehaviours[id] = behavior
        
        output.viewDidAddEnemy(withId: id)
    }
    
    func addVelocity(_ velocity: CGPoint, forEnemyWithId id: String) {
        guard let enemyLogoView = enemies[id] else {return}
        guard let behavior = enemiesMoveBehaviours[id] else {return}
        
        behavior.addLinearVelocity(velocity, for: enemyLogoView)
    }
    
    func stopEnemy(withId id: String) {
        guard let enemyLogoView = enemies[id] else {return}
        guard let behavior = enemiesMoveBehaviours[id] else {return}
        
        let currentVelocity = behavior.linearVelocity(for: enemyLogoView)
        let inverseVelocity = currentVelocity.inverse()
        
        behavior.addLinearVelocity(inverseVelocity, for: enemyLogoView)
    }
    
    func killEnemy(withId id: String) {
        guard let enemyLogoView = enemies[id] else {return}
        
        enemyLogoView.configureImageAsDead()
    }
    
    func removeEnemy(withId id: String, animated: Bool) {
        guard let enemyLogoView = enemies[id] else {return}
        guard let behavior = enemiesMoveBehaviours[id] else {return}
        
        animator.removeBehavior(behavior)
        behavior.removeItem(enemyLogoView)
        enemiesMoveBehaviours[id] = nil
        
        if animated {
            UIView.animate(withDuration: 0.5, animations: {
                enemyLogoView.alpha = 0.0
            }, completion: { (completed) in
                enemyLogoView.removeFromSuperview()
            })
        } else {
            enemyLogoView.removeFromSuperview()
        }
    }
}


extension GameVC: EnemyLogoViewOutput {
    
    func didTouchDown(_ sender: EnemyLogoView) {
        guard let id = sender.enemyId else {
            assert(false, "EnemyLogoView has no id")
        }
        
        output.viewDidTouchDownEnemy(withId: id)
    }
    
    func didTouchUp(_ sender: EnemyLogoView) {
        guard let id = sender.enemyId else {
            assert(false, "EnemyLogoView has no id")
        }
        
        output.viewDidTouchUpEnemy(withId: id)
    }
}

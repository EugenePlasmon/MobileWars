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
    
    lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        return behavior
    }()
    
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
        gameSceneView.addSubview(enemyLogoView)
        enemyLogoView.center = point
        
        let behavior = UIDynamicItemBehavior()
        behavior.resistance = 0
        behavior.addItem(enemyLogoView)
        animator.addBehavior(behavior)
        
        enemies[id] = enemyLogoView
        enemiesMoveBehaviours[id] = behavior
        
        collisionBehavior.addItem(enemyLogoView)
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collisionBehavior)
        
        output.viewDidAddEnemy(withId: id)
    }
    
    func addVelocity(_ velocity: CGPoint, forEnemyWithId id: String) {
        guard let enemyLogoView = enemies[id] else {return}
        guard let behavior = enemiesMoveBehaviours[id] else {return}
        
        behavior.addLinearVelocity(velocity, for: enemyLogoView)
    }
}

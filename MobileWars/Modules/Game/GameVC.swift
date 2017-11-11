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
    var enemies: [EnemyLogoView] = []
    
    lazy var animator: UIDynamicAnimator = {
        UIDynamicAnimator(referenceView: self.gameSceneView)
    }()
    
    lazy var moveBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = false
        return behavior
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
        
        enemies.append(enemyLogoView)
        
        moveBehavior.addItem(enemyLogoView)
        moveBehavior.addLinearVelocity(CGPoint(x: 1, y: 20), for: enemyLogoView)
        
        animator.addBehavior(moveBehavior)
    }
}

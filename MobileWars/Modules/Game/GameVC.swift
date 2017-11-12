//
//  GameVC.swift
//  MobileWars
//
//  Created by Evgeny Kireev on 11.11.17.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import UIKit


private let killEnemySlowAngularVelocity: RadiansPerSecond = 1.5
private let killEnemyFastAngularVelocity: RadiansPerSecond = 5.0

private let gameSceneViewTopGradientColor =
    UIColor(red: 237.0/255.0, green: 237.0/255.0, blue: 237.0/255.0, alpha: 1.0)
private let gameSceneViewBottomGradientColor =
    UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)


class GameVC: UIViewController {
    
    var output: GameVCOutput!
    var enemies: [String: EnemyLogoView] = [:]
    var defenders: [String: DefenderLogoView] = [:]
    var enemiesMoveBehaviours: [String: UIDynamicItemBehavior] = [:]
    
    lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.collisionDelegate = self
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    lazy var animator: UIDynamicAnimator = {
        UIDynamicAnimator(referenceView: self.gameSceneView)
    }()
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var gameSceneView: UIView! {
        didSet {
            let gradient = CAGradientLayer()
            gradient.frame.size = gameSceneView.frame.size
            gradient.colors = [
                gameSceneViewTopGradientColor.cgColor,
                gameSceneViewBottomGradientColor.cgColor
            ]
            gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
            gameSceneView.layer.addSublayer(gradient)
        }
    }
    @IBOutlet weak var scoreLabel: UILabel! {
        didSet {
            scoreLabel.text = "0"
        }
    }
    @IBOutlet weak var comboLabel: UILabel!
    @IBOutlet weak var comboBGView: UIView! {
        didSet {
            comboBGView.layer.cornerRadius = comboBGView.bounds.width / 2
        }
    }
    
    //MARK: - Init
    
    public class func createModule(withTeam team: Team) -> GameVC {
        let nib = UINib(nibName: "GameVC", bundle: nil)
        let vc = nib.instantiate(withOwner: self,
                                   options: [:]).first as! GameVC
        vc.output = GamePresenter(userInterface: vc, team: team)
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: gameSceneView)
        
        if touchLocation.y >= 0 {
            output.viewDidTouchOnBG()
        }
    }
    
    //MARK: - Private
    
    private func nearestAngleForHorizontalPosition(fromCurrentAngle angle: Radians) -> Radians {
        var nearestAngle: Radians!
        
        //we want to rotate still to left even at small positive angle
        let maxPositiveAngleForRotateToLeft: Radians = 0.1
        
        if angle >= -Radians.pi && angle <= maxPositiveAngleForRotateToLeft {
            nearestAngle = -Radians.pi / 2
        } else {
            nearestAngle = Radians.pi / 2
        }
        
        return nearestAngle
    }
}


//MARK: - GameVCInput
extension GameVC: GameVCInput {
    
    func addEnemy(at point: CGPoint, withId id: String, ofTeam team: Team) {
        let enemyLogoView = EnemyLogoView.createView(withTeam: team)
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
        
        collisionBehavior.addItem(enemyLogoView)
        animator.addBehavior(collisionBehavior)
        
        output.viewDidAddEnemy(withId: id)
    }
    
    func addDefender(at point: CGPoint, withId id: String, ofTeam team: Team) {
        let defenderLogoView = DefenderLogoView.createView(withTeam: team)
        defenderLogoView.defenderId = id
        defenderLogoView.center = point
        
        gameSceneView.addSubview(defenderLogoView)
        
        defenders[id] = defenderLogoView
        
        collisionBehavior.addBoundary(withIdentifier: id as NSCopying,
                                                 for: UIBezierPath(rect: defenderLogoView.frame))
        
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
        
        let currentAngle = enemyLogoView.currentRotationAngle()
        let toAngle = nearestAngleForHorizontalPosition(fromCurrentAngle: currentAngle)
        
        enemyLogoView.rotate(toAngle: toAngle,
                             withAngularVelocity: killEnemySlowAngularVelocity)
    }
    
    func dropDownEnemy(withId id: String) {
        guard let enemyLogoView = enemies[id] else {return}
        
        let currentAngle = enemyLogoView.currentRotationAngle()
        let toAngle = nearestAngleForHorizontalPosition(fromCurrentAngle: currentAngle)
        
        enemyLogoView.rotate(toAngle: toAngle,
                             withAngularVelocity: killEnemyFastAngularVelocity)
    }
    
    func removeEnemy(withId id: String, withFadeOut: Bool) {
        guard let enemyLogoView = enemies[id] else {return}
        guard let behavior = enemiesMoveBehaviours[id] else {return}
        
        animator.removeBehavior(behavior)
        collisionBehavior.removeItem(enemyLogoView)
        behavior.removeItem(enemyLogoView)
        enemiesMoveBehaviours[id] = nil
        
        if withFadeOut {
            UIView.animate(withDuration: 0.5, animations: {
                enemyLogoView.alpha = 0.0
            }, completion: { (completed) in
                enemyLogoView.removeFromSuperview()
            })
        } else {
            enemyLogoView.removeFromSuperview()
        }
    }
    
    func removeEnemyWithExplosion(withId id: String) {
        guard let enemyLogoView = enemies[id] else {return}
        guard let behavior = enemiesMoveBehaviours[id] else {return}
        
        animator.removeBehavior(behavior)
        collisionBehavior.removeItem(enemyLogoView)
        behavior.removeItem(enemyLogoView)
        enemiesMoveBehaviours[id] = nil
        
        enemyLogoView.showExplosion()
        
        UIView.animate(withDuration: 0.5, animations: {
            enemyLogoView.alpha = 0.0
        }, completion: { (completed) in
            enemyLogoView.removeFromSuperview()
        })
    }
    
    func removeDefender(withId id: String) {
        guard let defenderLogoView = defenders[id] else {return}
        collisionBehavior.removeBoundary(withIdentifier: defenderLogoView.defenderId! as NSString)
        collisionBehavior.removeItem(defenderLogoView)
        enemiesMoveBehaviours[id] = nil
        
        defenderLogoView.showExplosion()
        
        UIView.animate(withDuration: 0.5, animations: {
            defenderLogoView.alpha = 0.0
        }, completion: { (completed) in
            defenderLogoView.removeFromSuperview()
        })

        
    }
    
    func updateScoreLabel(withScore score: Int) {
        let stringScore = "\(score)"
        scoreLabel.text = stringScore
    }
    
    func showComboLabel(withRate rate: Int) {
        UIView.animate(withDuration: 0.2) {
            self.comboBGView.alpha = 1.0
            self.comboLabel.text = "x\(rate)"
            self.comboLabel.alpha = 1.0
        }
    }
    
    func hideComboLabel(withFadeOut: Bool) {
        if withFadeOut {
            UIView.animate(withDuration: 0.2, animations: {
                self.comboLabel.alpha = 0
                self.comboBGView.alpha = 0
            }, completion: { (completed) in
                self.comboLabel.text = nil
            })
        } else {
            self.comboLabel.alpha = 0
            self.comboLabel.text = nil
            self.comboBGView.alpha = 0
        }
    }
    
    func getGameViewFrame() -> CGRect {
        return gameSceneView.frame
    }
    
    func getVelocityOfEnemy(withId id: String) -> CGPoint {
        guard let enemyLogoView = enemies[id] else {return .zero}
        guard let behavior = enemiesMoveBehaviours[id] else {return .zero}
        
        return behavior.linearVelocity(for: enemyLogoView)
    }

}


//MARK: - EnemyLogoViewOutput
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


//MARK: - UICollisionBehaviorDelegate
extension GameVC: UICollisionBehaviorDelegate {
    
    //identifier is equal to defender id
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor
                                 item: UIDynamicItem, withBoundaryIdentifier
                           identifier: NSCopying?,
                                 at p: CGPoint) {
        let enemyView = item as! EnemyLogoView
        
        guard let enemyId = enemyView.enemyId else {return}
        guard let defenderId = identifier as? NSString else {return}
        
        output.viewDidCollide(enemyWithId: enemyId, andDefenderWithId: defenderId as String)
    }
}

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
    
    //MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        output.viewDidPressBackButton()
    }
}


//MARK: - GameVCInput
extension GameVC: GameVCInput {
    
    func addEnemy(at point: CGPoint) {
        let enemyLogoView = EnemyLogoView.createView()
        enemies.append(enemyLogoView)
        
        gameSceneView.addSubview(enemyLogoView)
        
        enemyLogoView.center = point
    }
}

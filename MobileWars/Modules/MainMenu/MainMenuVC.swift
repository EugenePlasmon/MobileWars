//
//  MainMenuVC.swift
//  MobileWars
//
//  Created by Evgeny Kireev on 11.11.17.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import UIKit


class MainMenuVC: UIViewController {
    
    var output: MainMenuVCOutput!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var scoresButton: UIButton!
    
    //MARK: - Init
    
    class func createModule() -> MainMenuVC {
        let nib = UINib(nibName: "MainMenuVC", bundle: nil)
        let vc = nib.instantiate(withOwner: self,
                                   options: [:]).first as! MainMenuVC
        vc.output = MainMenuPresenter(userInterface: vc)
        
        return vc
    }
    
    //MARK: - Lifecycle
    
    //MARK: - Actions
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        output.didPressPlayButton()
    }
    
    @IBAction func scoresButtonPressed(_ sender: UIButton) {
        
    }
}


extension MainMenuVC: MainMenuVCInput {
    
}

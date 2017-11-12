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
    
    @IBOutlet weak var playIOSTeamButton: UIButton!
    @IBOutlet weak var playAndroidTeamButton: UIButton!
    @IBOutlet weak var recordsButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var topSeparatorView: UIView!
    @IBOutlet weak var bottomSeparatorView: UIView!
    
    //MARK: - Init
    
    public class func createModule() -> MainMenuVC {
        let nib = UINib(nibName: "MainMenuVC", bundle: nil)
        let vc = nib.instantiate(withOwner: self,
                                   options: [:]).first as! MainMenuVC
        vc.output = MainMenuPresenter(userInterface: vc)
        
        return vc
    }
    
    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Actions
    
    @IBAction func playIOSTeamButtonPressed(_ sender: UIButton) {
        output.didPressPlayIOSTeamButton()
    }
    
    @IBAction func playAndroidTeamButtonPressed(_ sender: UIButton) {
        output.didPressPlayAndroidTeamButton()
    }
    
    @IBAction func recordsButtonPressed(_ sender: UIButton) {
        output.didPressRecordsButton()
    }

    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        
    }
}


extension MainMenuVC: MainMenuVCInput {
    
}

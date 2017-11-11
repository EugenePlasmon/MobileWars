//
//  SettingsVC.swift
//  MobileWars
//
//  Created by Evgeny Kireev on 11.11.17.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    public class func createModule() -> MainMenuVC {
        let nib = UINib(nibName: "MainMenuVC", bundle: nil)
        let vc = nib.instantiate(withOwner: self,
                                 options: [:]).first as! MainMenuVC
        vc.output = MainMenuPresenter(userInterface: vc)
        
        return vc
    }

}

//
//  SettingsVC.swift
//  MobileWars
//
//  Created by Evgeny Kireev on 11.11.17.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    var output: SettingsVCOutput!
    let settingsCellIdentifier = "settingsCellIdentifier"
    let options = ["Vibration after kill enemy",
                   "Vibration after lose life",
                   "Sounds in app"]
    
    @IBOutlet weak var tableView: UITableView!
    
    public class func createModule() -> SettingsVC {
        let nib = UINib(nibName: "SettingsVC", bundle: nil)
        let vc = nib.instantiate(withOwner: self,
                                   options: [:]).first as! SettingsVC
        vc.output = SettingsPresenter(userInterface: vc)
        
        return vc
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "SettingsCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: settingsCellIdentifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    //MARK: - Actions
    @IBAction func backButtonPressed(_ sender: UIButton) {
        output.viewDidPressBackButton()
    }
}


extension SettingsVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: settingsCellIdentifier,
                                                            for: indexPath) as! SettingsCell
        cell.output = self
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.settingTextLabel.text = options[indexPath.row]
                cell.switchSetting.setOn(SettingsService.vibrationOnEnemyIsOn(), animated: false)
            } else if indexPath.row == 1 {
                cell.settingTextLabel.text = options[indexPath.row]
                cell.switchSetting.setOn(SettingsService.vibrationOnCollisionIsOn(), animated: false)
            }
        } else if indexPath.section == 1 {
            cell.settingTextLabel.text = options[2]
            cell.switchSetting.setOn(SettingsService.soundsIsOn(), animated: false)
        }
        
        return cell
    }
}


extension SettingsVC: SettingsCellOutput {
    
    func cell(_ cell: SettingsCell, didChangeSwitcherValueTo newSwitcherValue: Bool) {
        let indexPath = tableView.indexPath(for: cell)
        
        if indexPath == nil {return}
        
        if indexPath!.section == 0 {
            if indexPath!.row == 0 {
                //vib enemy
                output.viewDidChangeVibrationOnEnemySwitcher(toValue: newSwitcherValue)
            } else if indexPath!.row == 1 {
                //vib defender
                output.viewDidChangeVibrationOnCollideSwitcher(toValue: newSwitcherValue)
            }
        } else if indexPath!.section == 1 {
            //sounds
            output.viewDidChangeSoundsSwitcher(toValue: newSwitcherValue)
        }
    }
}

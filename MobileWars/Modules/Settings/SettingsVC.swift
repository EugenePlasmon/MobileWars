//
//  SettingsVC.swift
//  MobileWars
//
//  Created by Evgeny Kireev on 11.11.17.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import UIKit


private let settingsCellIdentifier = "settingsCellIdentifier"


class SettingsVC: UIViewController {

    var output: SettingsVCOutput!

    let vibrationOptions = ["Vibration after kill enemy",
                            "Vibration after lose life"]
    let soundOptions = ["Sounds in app"]
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    enum SectionType: Int {
        case vibration = 0
        case sound = 1
        
        public static func sectionType(fromInt int: Int) -> SectionType? {
            switch int {
            case 0: return .vibration
            case 1: return .sound
            default: return nil
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            registerReusableCells()
        }
    }
    
    public class func createModule() -> SettingsVC {
        let nib = UINib(nibName: "SettingsVC", bundle: nil)
        let vc = nib.instantiate(withOwner: self,
                                   options: [:]).first as! SettingsVC
        vc.output = SettingsPresenter(userInterface: vc)
        
        return vc
    }
    
//MARK: - Private
    
    private func registerReusableCells() {
        let nib = UINib(nibName: "SettingsCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: settingsCellIdentifier)
    }
    
//MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        output.viewDidPressBackButton()
    }
}


//MARK: - SettingsCellOutput

extension SettingsVC: SettingsCellOutput {
    
    func cell(_ cell: SettingsCell, didChangeSwitcherValueTo newSwitcherValue: Bool) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        guard let sectionType = SectionType.sectionType(fromInt: indexPath.section) else { return }
        
        switch sectionType {
        case .vibration:
            if indexPath.row == 0 {
                output.viewDidChangeVibrationOnEnemySwitcher(toValue: newSwitcherValue)
            } else if indexPath.row == 1 {
                output.viewDidChangeVibrationOnCollideSwitcher(toValue: newSwitcherValue)
            }
        case .sound:
            output.viewDidChangeSoundsSwitcher(toValue: newSwitcherValue)
        }
    }
}


//MARK: - UITableViewDataSource

extension SettingsVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection
                       section: Int) -> Int {
        let sectionType = SectionType.sectionType(fromInt: section)!
        
        switch sectionType {
        case .vibration:
            return vibrationOptions.count
        case .sound:
            return soundOptions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: settingsCellIdentifier,
                                                            for: indexPath) as! SettingsCell
        let sectionType = SectionType.sectionType(fromInt: indexPath.section)!
        cell.output = self
        
        switch sectionType {
        case .vibration:
            let vibro = vibrationOptions[indexPath.row]
            if indexPath.row == 0 {
                cell.settingTextLabel.text = vibro
                cell.switchSetting.setOn(SettingsService.vibrationOnEnemyIsOn(), animated: false)
            } else if indexPath.row == 1 {
                cell.settingTextLabel.text = vibro
                cell.switchSetting.setOn(SettingsService.vibrationOnCollisionIsOn(), animated: false)
            }
        case .sound:
            let sound = soundOptions[indexPath.row]
            cell.settingTextLabel.text = sound
            cell.switchSetting.setOn(SettingsService.soundsIsOn(), animated: false)
        }
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension SettingsVC: UITableViewDelegate {
    
}

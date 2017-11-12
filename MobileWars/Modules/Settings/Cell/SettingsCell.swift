//
//  SettingsTableViewCell.swift
//  MobileWars
//
//  Created by Максим Бриштен on 12.11.2017.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import UIKit


@objc protocol SettingsCellOutput {
    
    func cell(_ cell: SettingsCell, didChangeSwitcherValueTo newSwitcherValue: Bool)
}


class SettingsCell: UITableViewCell {
    
    public weak var output: SettingsCellOutput?

    @IBOutlet weak var settingTextLabel: UILabel!
    @IBOutlet weak var switchSetting: UISwitch!
    
    //MARK: - Actions
    
    @IBAction func switcherDidChangeValue(_ sender: UISwitch) {
        if output == nil {return}
        
        output!.cell(self, didChangeSwitcherValueTo: sender.isOn)
    }
}

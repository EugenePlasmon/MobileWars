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
    let cellIdentifier = "cellIdentifier"
    let options = ["Вибрация при убийстве противника",
                   "Вибрация при убийстве союзника",
                   "Звук"]
    
    @IBOutlet weak var tableView: UITableView!
    
    public class func createModule() -> SettingsVC {
        let nib = UINib(nibName: "SettingsVC", bundle: nil)
        let vc = nib.instantiate(withOwner: self,
                                   options: [:]).first as! SettingsVC
        vc.output = SettingsPresenter(userInterface: vc)
        
        return vc
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "SettingsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SettingsTableViewCell
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.settingTextLabel.text = options[indexPath.row]
            } else if indexPath.row == 1 {
                cell.settingTextLabel.text = options[indexPath.row]
            }
        } else if indexPath.section == 1 {
            cell.settingTextLabel.text = options[2]
        }
        return cell
    }
}

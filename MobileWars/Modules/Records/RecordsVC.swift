//
//  RecordsVC.swift
//  MobileWars
//
//  Created by Evgeny Kireev on 12.11.17.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import UIKit


private let recordsCellReuseId = "recordsCellReuseId"


class RecordsVC: UIViewController {
    
    var output: RecordsVCOutput!
    private var records: [Record]!
    
    enum SectionType: Int {
        case records = 0
        
        //TODO: -
        //case achievements = 1
        
        public static func sectionType(fromInt int: Int) -> SectionType? {
            switch int {
            case 0:
                return .records
            default:
                return nil
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
    
    public class func createModule() -> RecordsVC {
        let nib = UINib(nibName: "RecordsVC", bundle: nil)
        let vc = nib.instantiate(withOwner: self,
                                   options: [:]).first as! RecordsVC
        vc.output = RecordsPresenter(userInterface: vc)
        
        return vc
    }

    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewDidConfigure()
    }
    
    //MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        output.viewDidPressBackButton()
    }
    
    //MARK: - Private
    
    private func registerReusableCells() {
        let nib = UINib(nibName: "RecordCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: recordsCellReuseId)
    }
}

    //MARK: TableViewDataSource

extension RecordsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection
                       section: Int) -> Int {
        let sectionType = SectionType.sectionType(fromInt: section)!
        
        switch sectionType {
        case .records:
            return records.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionType = SectionType.sectionType(fromInt: indexPath.section)!
        
        switch sectionType {
        case .records:
            let record = records[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: recordsCellReuseId, for: indexPath) as! RecordCell
            cell.configure(withRecord: record)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


//MARK: - TableViewDelegate

extension RecordsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionType = SectionType.sectionType(fromInt: indexPath.section)!
        
        switch sectionType {
        case .records:
            return RecordCell.height()
        }
    }
}

extension RecordsVC: RecordsVCInput {
    
    func configure(record: [Record]) {
        records = record
    }
    
}

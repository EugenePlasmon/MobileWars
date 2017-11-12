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
    
    private var records: [Record]!
    
    public class func createModule() -> RecordsVC {
        let nib = UINib(nibName: "RecordsVC", bundle: nil)
        let vc = nib.instantiate(withOwner: self,
                                   options: [:]).first as! RecordsVC
        vc.configure()
        
        return vc
    }

    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Private
    
    private func configure() {
        records = RecordsService.getRecordsFromCache()
    }
    
    private func registerReusableCells() {
        let nib = UINib(nibName: "RecordCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: recordsCellReuseId)
    }
}


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
}


extension RecordsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionType = SectionType.sectionType(fromInt: indexPath.section)!
        
        switch sectionType {
        case .records:
            return RecordCell.height()
        }
    }
    
}

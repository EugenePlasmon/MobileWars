//
//  RecordsPresenter.swift
//  MobileWars
//
//  Created by leonard on 18.11.2017.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//
import Foundation


class RecordsPresenter: NSObject {
    
    unowned var userInterface: RecordsVC
    
    init(userInterface: RecordsVC) {
        self.userInterface = userInterface
    }
    
//MARK: - Private
    
    private func closeModule() {
        userInterface.dismiss(animated: true, completion: nil)
    }
}

//MARK: - RecordsVCOutput

extension RecordsPresenter: RecordsVCOutput {
    
    func viewDidPressBackButton() {
        closeModule()
    }
    
    func viewWillAppear() {
        let records = RecordsService.getRecordsFromCache()
        userInterface.configure(withRecords: records)
    }
}

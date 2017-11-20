//
//  RecordVCInterface.swift
//  MobileWars
//
//  Created by leonard on 18.11.2017.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

protocol RecordsVCInput {
    
    func configure(withRecords records: [Record])
    
}

protocol RecordsVCOutput {
    
    func viewDidPressBackButton()
    
    func viewWillAppear()
    
}

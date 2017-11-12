//
//  RecordCell.swift
//  MobileWars
//
//  Created by Evgeny Kireev on 12.11.17.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import UIKit


class RecordCell: UITableViewCell {
    
    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    

    public func configure(withRecord record: Record) {
        configureTeamImage(fromRecord: record)
        configureScore(fromRecord: record)
        configureDate(fromRecord: record)
    }
    
    public class func height() -> CGFloat {
        return 64.0
    }
    
    private func configureTeamImage(fromRecord record: Record) {
        switch record.team {
        case .ios:
            teamImage.image = #imageLiteral(resourceName: "apple_default")
        case .android:
            teamImage.image = #imageLiteral(resourceName: "android_default")
        }
    }
    
    private func configureScore(fromRecord record: Record) {
        scoreLabel.text = "\(record.reachedScore)"
    }
    
    private func configureDate(fromRecord record: Record) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm dd/MM/yy"
        let dateString = dateFormatter.string(from: record.date)
        dateLabel.text = dateString
    }
}

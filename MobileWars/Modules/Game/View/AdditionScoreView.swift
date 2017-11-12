//
//  AdditionScoreView.swift
//  MobileWars
//
//  Created by Evgeny Kireev on 12.11.17.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import UIKit


class AdditionScoreView: UIView {

    @IBOutlet public weak var additionScoreLabel: UILabel! {
        didSet {
            additionScoreLabel.layer.shadowColor = UIColor.black.cgColor
            additionScoreLabel.layer.shadowOpacity = 0.2
            additionScoreLabel.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            additionScoreLabel.layer.shadowRadius = 4.0
        }
    }
    
    public class func view() -> AdditionScoreView {
        let nib = UINib(nibName: "AdditionScoreView", bundle: nil)
        let view = nib.instantiate(withOwner: self,
                                     options: [:]).first as! AdditionScoreView
        
        return view
    }
    
    public class func image(withScore score: Int) -> UIImage {
        let view = self.view()
        view.additionScoreLabel.text = "+\(score)"
        
        return view.getImage()
    }
}

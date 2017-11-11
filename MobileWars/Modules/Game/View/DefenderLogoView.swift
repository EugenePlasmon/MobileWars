//
//  DefenderLogoView.swift
//  MobileWars
//
//  Created by Максим Бриштен on 11.11.2017.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import UIKit


class DefenderLogoView: UIView {

    public var defenderId: String?
    
    @IBOutlet weak var defenderImage: UIImageView!
    
    //MARK: - Public
    
    public class func createView() -> DefenderLogoView {
        let nib = UINib(nibName: "DefenderLogoView", bundle: nil)
        let view = nib.instantiate(withOwner: self,
                                     options: [:]).first as! DefenderLogoView
        view.configure()
        
        return view
    }
    
    public class func size() -> CGSize {
        return CGSize(width: 60, height: 60)
    }
    
    //MARK: - Private
    
    private func configure() {
        defenderImage.image = #imageLiteral(resourceName: "apple_default")
    }
}

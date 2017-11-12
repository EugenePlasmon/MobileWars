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
    
    public func configureImageAsDefault() {
        defenderImage.image = #imageLiteral(resourceName: "apple_default")
        
    }
    
    public func returnAnimatedImages() -> [UIImage] {
        let explosive1 = UIImage(named: "explosion_animation_1")!
        let explosive2 = UIImage(named: "explosion_animation_2")!
        let explosive3 = UIImage(named: "explosion_animation_3")!
        let explosive4 = UIImage(named: "explosion_animation_4")!
        let explosive5 = UIImage(named: "explosion_animation_5")!
        let explosive6 = UIImage(named: "explosion_animation_6")!
        let images: [UIImage] = [explosive1, explosive2, explosive3, explosive4, explosive5, explosive6]
        return images
    }
    
    //MARK: - Private
    
    private func configure() {
        configureImageAsDefault()
    }
}

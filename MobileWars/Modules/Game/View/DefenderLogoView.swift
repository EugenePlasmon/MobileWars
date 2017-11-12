//
//  DefenderLogoView.swift
//  MobileWars
//
//  Created by Максим Бриштен on 11.11.2017.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import UIKit


private let explosionAnimationDuration = 5.0


class DefenderLogoView: UIView {

    public var defenderId: String?
    
    private var team: Team!
    
    @IBOutlet weak var defenderImage: UIImageView!
    
    //MARK: - Lifecycle
    
    deinit {
        defenderImage.stopAnimating()
    }
    
    //MARK: - Public
    
    public class func createView(withTeam team: Team) -> DefenderLogoView {
        let nib = UINib(nibName: "DefenderLogoView", bundle: nil)
        let view = nib.instantiate(withOwner: self,
                                     options: [:]).first as! DefenderLogoView
        view.team = team
        view.configure()
        
        return view
    }
    
    public class func size() -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    public func configureImageAsDefault() {
        var image: UIImage!
        
        switch team {
        case .ios:
            image = #imageLiteral(resourceName: "apple_default")
        case .android:
            image = #imageLiteral(resourceName: "android_default")
        default:
            return
        }
        
        defenderImage.image = image
    }
    
    public func showExplosion() {
        defenderImage.animationImages = getExplosionImagesToAnimate()
        defenderImage.startAnimating()
    }
    
    //MARK: - Private
    
    private func getExplosionImagesToAnimate() -> [UIImage] {
        let explosive1 = UIImage(named: "explosion_animation_1")!
        let explosive2 = UIImage(named: "explosion_animation_2")!
        let explosive3 = UIImage(named: "explosion_animation_3")!
        let explosive4 = UIImage(named: "explosion_animation_4")!
        let explosive5 = UIImage(named: "explosion_animation_5")!
        let explosive6 = UIImage(named: "explosion_animation_6")!
        let images = [explosive1, explosive2, explosive3, explosive4, explosive5, explosive6]
        return images
    }
    
    //MARK: - Private
    
    private func configure() {
        configureImageAsDefault()
    }
}

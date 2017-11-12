//
//  EnemyLogoView.swift
//  MobileWars
//
//  Created by Evgeny Kireev on 11.11.17.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import UIKit


public typealias Radians = Float
public typealias RadiansPerSecond = Float


private let androidColor = UIColor(red: 153.0/255.0, green: 204.0/255.0, blue: 3.0/255.0, alpha: 1.0)


@objc protocol EnemyLogoViewOutput {
    
    func didTouchDown(_ sender: EnemyLogoView)
    
    func didTouchUp(_ sender: EnemyLogoView)
}


class EnemyLogoView: UIView {

    public weak var output: EnemyLogoViewOutput?
    public var enemyId: String?
    private var currentRotationAngle = 0.0
    var images: [UIImage] = []
    
    let explosive1 = UIImage(named: "explosion_animation_1")!
    let explosive2 = UIImage(named: "explosion_animation_2")!
    let explosive3 = UIImage(named: "explosion_animation_3")!
    let explosive4 = UIImage(named: "explosion_animation_4")!
    let explosive5 = UIImage(named: "explosion_animation_5")!
    let explosive6 = UIImage(named: "explosion_animation_6")!
    
    @IBOutlet weak var enemyImage: UIImageView!
    
    //MARK: - Public
    
    public class func createView() -> EnemyLogoView {
        let nib = UINib(nibName: "EnemyLogoView", bundle: nil)
        let view = nib.instantiate(withOwner: self,
                                     options: [:]).first as! EnemyLogoView
        view.configure()
        
        return view
    }
    
    public func configureImageAsDefault() {
        enemyImage.image = #imageLiteral(resourceName: "android_default")
    }
    
    public func configureImageAsDead() {
        enemyImage.image = #imageLiteral(resourceName: "android_dead")
    }
    
    public func configureImageAsExplosive() -> [UIImage] {
        images = [explosive1, explosive2, explosive3, explosive4, explosive5, explosive6]
        return images
    }
    
    public func rotate(toAngle: Radians, withAngularVelocity angularVelocity: RadiansPerSecond) {
        let zKeyPath = "layer.presentationLayer.transform.rotation.z"
        let currentAngle = (value(forKeyPath: zKeyPath) as? NSNumber)?.floatValue ?? 0.0
        
        let angleDiff = abs(toAngle - currentAngle)
        let duration = Double(angleDiff / angularVelocity)
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.duration = duration
        rotateAnimation.fillMode = kCAFillModeForwards;
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.fromValue = currentAngle
        rotateAnimation.toValue = toAngle
        
        layer.add(rotateAnimation, forKey: "slowRotation")
    }

    //MARK: - Private
    
    private func configure() {
        configureImageAsDefault()
    }
    
    //MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>,
                              with event: UIEvent?) {
        output?.didTouchDown(self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>,
                              with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>,
                              with event: UIEvent?) {
        output?.didTouchUp(self)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>,
                                  with event: UIEvent?) {
        
    }
}

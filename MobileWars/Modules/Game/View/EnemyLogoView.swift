//
//  EnemyLogoView.swift
//  MobileWars
//
//  Created by Evgeny Kireev on 11.11.17.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import UIKit


@objc protocol EnemyLogoViewOutput {
    
    func didTouchDown(_ sender: EnemyLogoView)
    
    func didTouchUp(_ sender: EnemyLogoView)
}


class EnemyLogoView: UIView {

    public weak var output: EnemyLogoViewOutput?
    public var enemyId: String?
    
    @IBOutlet weak var enemyImage: UIImageView!
    
    class func createView() -> EnemyLogoView {
        let nib = UINib(nibName: "EnemyLogoView", bundle: nil)
        let view = nib.instantiate(withOwner: self,
                                     options: [:]).first as! EnemyLogoView
        view.configure()
        
        return view
    }
    
    //MARK: - Private
    
    private func configure() {
        configureImage()
    }
    
    private func configureImage() {
        let image = #imageLiteral(resourceName: "android_default").withRenderingMode(.alwaysTemplate)
        enemyImage.image = image
        enemyImage.tintColor = UIColor(red: 153.0/255.0, green: 204.0/255.0, blue: 3.0/255.0, alpha: 1.0)
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

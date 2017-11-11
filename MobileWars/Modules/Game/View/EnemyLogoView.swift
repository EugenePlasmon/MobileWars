//
//  EnemyLogoView.swift
//  MobileWars
//
//  Created by Evgeny Kireev on 11.11.17.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import UIKit


class EnemyLogoView: UIView {

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
        enemyImage.tintColor = .green
    }
    
    //MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>,
                              with event: UIEvent?) {
        print("touchesBegan")
        enemyImage.tintColor = .blue
    }
    
    override func touchesMoved(_ touches: Set<UITouch>,
                              with event: UIEvent?) {
        print("touchesMoved")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>,
                              with event: UIEvent?) {
        print("touchesEnded")
        enemyImage.tintColor = .red
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>,
                                  with event: UIEvent?) {
        print("touchesCancelled")
        enemyImage.tintColor = .red
    }
}

//
//  UIViewExtensions.swift
//  MobileWars
//
//  Created by Evgeny Kireev on 12.11.17.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import UIKit


extension UIView {
    
    func getImage() -> UIImage {
        UIGraphicsBeginImageContext(frame.size)
        layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return UIImage(cgImage: image!.cgImage!)
    }
}

//
//  CardView.swift
//  HealthAI
//
//  Created by Feng Guo on 10/22/18.
//  Copyright © 2018 Team9. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CardView: UIView {
    
    @IBInspectable var cornerradius :CGFloat = 2
    
    @IBInspectable var shadowOffSetWidth : CGFloat = 0
    
    @IBInspectable var shadowOffSetHeight : CGFloat = 5
    
    @IBInspectable var shadowColor : UIColor = UIColor.black
    
    @IBInspectable var shadowOpacity : CGFloat = 0.5
    
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerradius
        
        layer.shadowColor = shadowColor.cgColor
        
        layer.shadowOffset = CGSize(width: shadowOffSetWidth, height: shadowOffSetHeight)
        
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerradius)
        
        layer.shadowPath = shadowPath.cgPath
        
        layer.shadowOpacity = Float(shadowOpacity)
        
        
        
    }
    
}

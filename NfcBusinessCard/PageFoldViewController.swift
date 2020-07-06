//
//  PageFoldViewController.swift
//  NfcBusinessCard
//
//  Created by Oscar Berggren on 2020-06-23.
//  Copyright © 2020 Oscar Berggren. All rights reserved.
//

import Foundation
import UIKit

class PageFoldViewController: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIBezierPath()
        
        context.move(to: CGPoint(x: 20, y: 3))
        context.addQuadCurve(to: CGPoint(x: bounds.width + 20, y: 0), controlPoint: CGPoint(x: bounds.width/2, y: 20))
        context.addQuadCurve(to: CGPoint(x: 0, y: bounds.height + 20), controlPoint: CGPoint(x: bounds.width/2 + 15, y: bounds.height/2 + 15))
        context.addQuadCurve(to: CGPoint(x: 0, y: 20), controlPoint: CGPoint(x: 10, y: bounds.height/2))
        context.addQuadCurve(to: CGPoint(x: 20, y: 3), controlPoint: CGPoint(x: 0, y: 0))
        
        context.fill()
        UIColor.white.setFill()
        context.stroke()

        let gradient = CAGradientLayer()
        gradient.frame = context.bounds
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.5)
        
        let black = UIColor(displayP3Red: 190/255, green: 190/255, blue: 190/255, alpha: 1)
        let grey = UIColor(displayP3Red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        
        gradient.locations = [0.0, 0.8, 0.9, 1.0]
        gradient.colors = [UIColor.white.cgColor, black.cgColor, grey.cgColor, black.cgColor]

        let shapeMask = CAShapeLayer()
        shapeMask.path = context.cgPath
        gradient.mask = shapeMask

        self.layer.addSublayer(gradient)
        
        self.layer.masksToBounds = true
        self.layer.shadowOffset = CGSize(width: 10, height: 10)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.75
    }
}

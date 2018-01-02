//
//  GradientView.swift
//  ride-along-development
//
//  Created by Alisher Abdukarimov on 1/2/18.
//  Copyright © 2018 Alisher Abdukarimov. All rights reserved.
//

import UIKit

class GradientView: UIView {

    let gradient = CAGradientLayer()
    
    override func awakeFromNib() {
        setupGradientView()
    }
    
    func setupGradientView() {
        gradient.frame = self.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor(white: 1.0, alpha: 0.0).cgColor]
        
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 0, y: 1.0)
        
        gradient.locations = [0.8, 1.0]
        self.layer.addSublayer(gradient)
    }

}

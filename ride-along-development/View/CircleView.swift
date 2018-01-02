//
//  CircleView.swift
//  ride-along-development
//
//  Created by Alisher Abdukarimov on 1/2/18.
//  Copyright © 2018 Alisher Abdukarimov. All rights reserved.
//

import UIKit

class CircleView: UIView {

    @IBInspectable var borderColor: UIColor? {
        didSet {
            // This is where setup needs to be
        }
    }
    
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = self.bounds.width / 2
        self.layer.borderWidth = 1.5
        self.layer.borderColor = borderColor?.cgColor
        
    }

}

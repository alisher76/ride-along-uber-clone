//
//  RoundedShadowView.swift
//  ride-along-development
//
//  Created by Alisher Abdukarimov on 1/2/18.
//  Copyright © 2018 Alisher Abdukarimov. All rights reserved.
//

import UIKit

class RoundedShadowView: UIView {

    override func awakeFromNib() {
        setupView()
    }

    func setupView() {
        self.layer.cornerRadius = 5.0
        //self.clipsToBounds = true
        
        self.layer.shadowOpacity = 0.4
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        
    }
}

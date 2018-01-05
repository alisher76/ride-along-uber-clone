//
//  UIViewExtension.swift
//  ride-along-development
//
//  Created by Alisher Abdukarimov on 1/5/18.
//  Copyright © 2018 Alisher Abdukarimov. All rights reserved.
//

import UIKit

extension UIView {
    
    func fadeTo(alhpaValue value: CGFloat, withDuration duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.alpha = value
        }
    }
    
}

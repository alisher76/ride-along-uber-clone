//
//  RoundedCornerTxtField.swift
//  ride-along-development
//
//  Created by Alisher Abdukarimov on 1/5/18.
//  Copyright © 2018 Alisher Abdukarimov. All rights reserved.
//

import UIKit

class RoundedCornerTxtField: UITextField {
    
    var textRectOffset: CGFloat = 20

    override func awakeFromNib() {
        setupView()
        self.textColor = UIColor.darkGray
    }
    
    func setupView() {
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 0 + textRectOffset, y: 0 + (textRectOffset / 2), width: self.frame.width - textRectOffset, height: self.frame.height - textRectOffset)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 0 + textRectOffset, y: 0 + (textRectOffset / 2), width: self.frame.width - textRectOffset, height: self.frame.height - textRectOffset)
    }
}

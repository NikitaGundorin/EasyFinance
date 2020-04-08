//
//  AddButton.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 04.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

@IBDesignable class AddButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 24
        layer.backgroundColor = UIColor.systemBlue.cgColor
        titleLabel?.textColor = UIColor.white
        self.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    override public var isEnabled: Bool {
        didSet {
            if self.isEnabled {
                self.alpha = 1
            } else {
                self.alpha = 0.5
            }
        }
    }
}

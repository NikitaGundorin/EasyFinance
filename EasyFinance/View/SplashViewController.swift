//
//  SplashViewController.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 09.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet private weak var logoImage: UIImageView!
    @IBOutlet private weak var textImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textImage.transform = CGAffineTransform(translationX: 0, y: 20)
        textImage.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.textImage.alpha = 1
        })
        UIView.animate(withDuration: 0.6, animations: {
            self.textImage.transform = .identity
        })
    }
}

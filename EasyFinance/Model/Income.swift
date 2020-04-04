//
//  Income.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 04.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

class Income {
    var value: Float
    var date: Date
    
    init(value: Float) {
        self.value = value
        self.date = Date()
    }
}

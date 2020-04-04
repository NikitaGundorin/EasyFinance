//
//  Expence.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 04.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

class Expence {
    var value: Float
    var category: Category
    var date: Date
    
    init(value: Float, category: Category) {
        self.value = value
        self.category = category
        self.date = Date()
    }
}
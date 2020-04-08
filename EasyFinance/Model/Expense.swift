//
//  Expense.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 04.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation
import RealmSwift

class Expense: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var value: Float = 0
    @objc dynamic var category: Category? = nil
    @objc dynamic var date: Date = Date()
}

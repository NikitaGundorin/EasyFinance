//
//  Category.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 04.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var sortOrder: Int = 0
    @objc dynamic var type: Int = 0
    
    var categoryType: CategoryType {
        return CategoryType(rawValue: type) ?? .custom
    }
}

enum CategoryType: Int {
    case custom = 0
    case all = 1
    case other = 2
}

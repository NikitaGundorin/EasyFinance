//
//  CategoryViewModel.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 04.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryViewModel {
    var categories: Results<Category>
    let dbManager = DBManager.shared
    
    init() {
        categories = dbManager.getAllCategories()
    }
    
    func addCategory(name: String) throws {
        let category = Category()
        category.name = name
        try dbManager.addCategory(category: category)
    }
    
    func deleteCategory(row: Int) {
        let category = categories[row]
        dbManager.deleteCategory(category: category)
    }
}

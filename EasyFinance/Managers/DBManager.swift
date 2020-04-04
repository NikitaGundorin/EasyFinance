//
//  DBManager.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 04.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation
import RealmSwift

class DBManager {
    static var shared = DBManager()
    
    let realm = try! Realm()
    
    func getAllIncomes() -> Results<Income> {
        realm.objects(Income.self)
    }
    
    func addIncome(income: Income) {
        try! realm.write {
            realm.add(income)
        }
    }
    
    func deleteIncome(income: Income) {
        try! realm.write {
            realm.delete(income)
        }
    }
    
    func getAllCategories() -> Results<Category> {
        realm.objects(Category.self)
    }
    
    func addCategory(category: Category) {
        try! realm.write {
            realm.add(category)
        }
    }
    
    func deleteCategory(category: Category) {
        try! realm.write {
            realm.delete(category)
        }
    }
}

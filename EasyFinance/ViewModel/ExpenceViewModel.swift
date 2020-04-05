//
//  ExpenceViewModel.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 05.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation
import RealmSwift

class ExpenceViewModel {
    var expences: Results<Expence>
    let dbManager = DBManager.shared
    
    init(category: Category) {
        expences = dbManager.getAllExpencesForCategory(category: category)
    }
    
    func addExpence(name: String, value: String, category: Category) {
        guard let value = Float(value) else {
            print("error while converting string to float")
            return
        }
        let expence = Expence()
        expence.value = value
        expence.name = name
        expence.category = category
        dbManager.addExpence(expence: expence)
    }
    
    func deleteExpence(row: Int) {
        dbManager.deleteExpence(expence: expences[row])
    }
}

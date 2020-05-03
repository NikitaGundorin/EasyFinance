//
//  ExpenseViewModel.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 05.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation
import RealmSwift

class ExpenseViewModel {
    var expenses: Results<Expense>
    private let dbManager = DBManager.shared
    
    init(category: Category) {
        if category.categoryType == .all {
            expenses = dbManager.getAllExpenses(ascending: false)
            return
        }
        expenses = dbManager.getAllExpenses(forCategory: category, ascending: false)
    }
    
    func addExpense(name: String, value: String, category: Category) {
        guard let value = Float(value) else {
            print("error while converting string to float")
            return
        }
        let expense = Expense()
        expense.value = value
        expense.name = name
        expense.category = category
        dbManager.addExpense(expense: expense)
    }
    
    func deleteExpense(row: Int) {
        dbManager.deleteExpense(expense: expenses[row])
    }
}

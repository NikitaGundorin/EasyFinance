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
    let dbManager = DBManager.shared
    
    init(category: Category) {
        if category.name == "Все" {
            expenses = dbManager.getAllExpenses()
            return
        }
        expenses = dbManager.getAllExpensesForCategory(category: category)
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

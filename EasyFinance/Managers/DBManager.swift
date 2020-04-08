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
        
    func getBalance() -> Balance {
        realm.objects(Balance.self).first!
    }
    
    func updateBalance(value: Float) {
        let balance = getBalance()
        try! realm.write {
            balance.value += value
        }
    }
    
    func getAllIncomes() -> Results<Income> {
        realm.objects(Income.self).sorted(byKeyPath: "date", ascending: true)
    }
    
    func getAllIncomesForInterval(interval: DateInterval) -> Results<Income> {
        return realm.objects(Income.self)
            .filter("date >= %@ && date <= %@", interval.start, interval.end)
            .sorted(byKeyPath: "date", ascending: true)
    }
    
    func addIncome(income: Income) {
        try! realm.write {
            realm.add(income)
        }
        updateBalance(value: income.value)
    }
    
    func deleteIncome(income: Income) {
        let value = -income.value
        try! realm.write {
            realm.delete(income)
        }
        updateBalance(value: value)
    }
    
    func getAllCategories() -> Results<Category> {
        realm.objects(Category.self).sorted(byKeyPath: "name").sorted(byKeyPath: "sortOrder")
    }
    
    func addCategory(category: Category) throws {
        if realm.objects(Category.self).filter("name == %@", category.name).first != nil {
            throw DBError.duplicate
        }
        
        try! realm.write {
            realm.add(category)
        }
    }
    
    func deleteCategory(category: Category) {
        guard let otherCategory = realm.objects(Category.self).filter("name == %@", "Другое").first,
            let allCategory = realm.objects(Category.self).filter("name == %@", "Все").first,
            category != otherCategory,
            category != allCategory
            else { return }
        let expenses = getAllExpensesForCategory(category: category)
        try! realm.write {
            for expense in expenses {
                expense.category = otherCategory
            }
            realm.delete(category)
        }
    }
    
    func getAllExpenses() -> Results<Expense> {
        realm.objects(Expense.self).sorted(byKeyPath: "date")
    }
    
    func getAllExpensesForCategory(category: Category) -> Results<Expense> {
        if (category.name == "Все") { return getAllExpenses()}
        return realm.objects(Expense.self).filter("category == %@", category)
            .sorted(byKeyPath: "date")
    }
    
    func getAllExpensesForInterval(interval: DateInterval, category: Category? = nil) -> Results<Expense> {
        let result = realm.objects(Expense.self)
            .filter("date >= %@ && date <= %@", interval.start, interval.end)
            .sorted(byKeyPath: "date")
        guard let category = category else { return result }
        if (category.name == "Все") { return result }
        return result.filter("category == %@", category)
    }
    
    func addExpense(expense: Expense) {
        try! realm.write {
            realm.add(expense)
        }
        updateBalance(value: -expense.value)
    }
    
    func deleteExpense(expense: Expense) {
        let value = expense.value
        try! realm.write {
            realm.delete(expense)
        }
        updateBalance(value: value)
    }
}

enum DBError: Error {
    case duplicate
}

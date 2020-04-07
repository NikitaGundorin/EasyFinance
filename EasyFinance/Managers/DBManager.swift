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
    
    func createBalance() -> Balance {
        let balance = Balance()
        let incomes = getAllIncomes()
        let expences = realm.objects(Expence.self)
        
        let totalIncome = incomes.map { $0.value }.reduce(0, +)
        let totalExpence = expences.map { $0.value }.reduce(0, +)
        
        balance.value = totalIncome - totalExpence
        
        try! realm.write {
            realm.add(balance)
        }
        return balance
    }
    
    func getBalance() -> Balance {
        guard let balance = realm.objects(Balance.self).first
            else { return createBalance() }
        
        return balance
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
        realm.objects(Category.self).sorted(byKeyPath: "name", ascending: true)
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
    
    func getAllExpences() -> Results<Expence> {
        realm.objects(Expence.self).sorted(byKeyPath: "date", ascending: true)
    }
    
    func getAllExpencesForCategory(category: Category) -> Results<Expence> {
        return realm.objects(Expence.self).filter("category == %@", category)
            .sorted(byKeyPath: "date", ascending: true)
    }
    
    func getAllExpencesForInterval(interval: DateInterval) -> Results<Expence> {
        return realm.objects(Expence.self)
            .filter("date >= %@ && date <= %@", interval.start, interval.end)
            .sorted(byKeyPath: "date", ascending: true)
    }
    
    func addExpence(expence: Expence) {
        try! realm.write {
            realm.add(expence)
        }
        updateBalance(value: -expence.value)
    }
    
    func deleteExpence(expence: Expence) {
        let value = expence.value
        try! realm.write {
            realm.delete(expence)
        }
        updateBalance(value: value)
    }
}

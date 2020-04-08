//
//  CategoryChartViewModel.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 08.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation
import RealmSwift
import Charts

class CategoryChartViewModel: ChartViewModelProtocol {
    var dbManager = DBManager.shared
    var category: Category?
    var expenses: Results<Expense>
    var incomes: Results<Income>? = nil
    var period = ChartPeriod.week {
        didSet {
            setup()
        }
    }
    var interval = DateInterval()
    
    init() {
        guard let category = category else {
            expenses = dbManager.getAllExpenses()
            return
        }
        expenses = dbManager.getAllExpensesForCategory(category: category)
    }
    
    func setup() {
        let today = Date()
        switch period {
        case .week:
            interval = DateInterval(start: today.previous(.monday, considerToday: true), end: today)
        case .month:
            let startOfMonth = today.startOfMonth()
            interval = DateInterval(start: startOfMonth, end: today)
        case .quarter:
            let startOfQuarter = today.startOfQuarter()
            interval = DateInterval(start: startOfQuarter, end: today)
        case .all:
            expenses = dbManager.getAllExpensesForCategory(category: category!)
            return
        }
        
        expenses = dbManager.getAllExpensesForInterval(interval: interval, category: category)
    }
}

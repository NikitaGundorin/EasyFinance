//
//  ChartViewModel.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 06.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation
import RealmSwift
import Charts

class ChartViewModel: ChartViewModelProtocol {
    var dbManager = DBManager.shared
    var incomes: Results<Income>?
    var expenses: Results<Expense>
    var period = ChartPeriod.week {
        didSet {
            setup()
        }
    }
    var interval = DateInterval()
    var category: Category? = nil
    
    init() {
        incomes = dbManager.getAllIncomes()
        expenses = dbManager.getAllExpenses()
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
            incomes = dbManager.getAllIncomes()
            expenses = dbManager.getAllExpenses()
            return
        }
        
        incomes = dbManager.getAllIncomesForInterval(interval: interval)
        expenses = dbManager.getAllExpensesForInterval(interval: interval)
    }
}

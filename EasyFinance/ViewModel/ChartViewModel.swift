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

class ChartViewModel {
    var dbManager = DBManager.shared
    var incomes: Results<Income>
    var expences: Results<Expence>
    var period = ChartPeriod.week {
        didSet {
            setup()
        }
    }
    var interval = DateInterval()
    
    init() {
        incomes = dbManager.getAllIncomes()
        expences = dbManager.getAllExpences()
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
            expences = dbManager.getAllExpences()
            return
        }
        
        incomes = dbManager.getAllIncomesForInterval(interval: interval)
        expences = dbManager.getAllExpencesForInterval(interval: interval)
    }
}

enum ChartPeriod {
    case week
    case month
    case quarter
    case all
}

extension ChartViewModel: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        FormatHelper.getShortFormattedDate(date: Date(timeIntervalSince1970: value))
    }
}

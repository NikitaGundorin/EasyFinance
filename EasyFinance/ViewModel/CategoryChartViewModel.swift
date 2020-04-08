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

class CategoryChartViewModel {
    var dbManager = DBManager.shared
    var category: Category?
    var expences: Results<Expence>
    var period = ChartPeriod.week {
        didSet {
            setup()
        }
    }
    var interval = DateInterval()
    
    init() {
        guard let category = category else {
            expences = dbManager.getAllExpences()
            return
        }
        expences = dbManager.getAllExpencesForCategory(category: category)
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
            expences = dbManager.getAllExpencesForCategory(category: category!)
            return
        }
        
        expences = dbManager.getAllExpencesForInterval(interval: interval, category: category)
    }
}

extension CategoryChartViewModel: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        FormatHelper.getShortFormattedDate(date: Date(timeIntervalSince1970: value))
    }
}

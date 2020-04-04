//
//  IncomeViewModel.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 04.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

class IncomeViewModel {
    var incomes: [Income] = []
    var balance: String {
        let total = incomes.map { income in return income.value }.reduce(0, +)
        return FormatHelper.formatCurrency(value: total)
    }
    
    init() {
        let one = Income(value: 100)
        let two = Income(value: 200.5)
        let three = Income(value: 50)
        
        incomes.append(contentsOf: [one, two, three])
    }
}

//
//  IncomeViewModel.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 04.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation
import RealmSwift

class IncomeViewModel {
    var incomes: Results<Income>
    var balance: Balance {
        return dbManager.getBalance()
    }
    var balanceText: String {
        return FormatHelper.getFormattedCurrency(value: balance.value)
    }
    let dbManager = DBManager.shared
    
    init() {
        incomes = dbManager.getAllIncomes(ascending: false)
    }
    
    func addIncome(value: String) {
        guard let value = Float(value) else {
            print("error while converting string to float")
            return
        }
        let income = Income()
        income.value = value
        dbManager.addIncome(income: income)
    }
    
    func deleteIncome(row: Int) {
        dbManager.deleteIncome(income: incomes[row])
    }
}

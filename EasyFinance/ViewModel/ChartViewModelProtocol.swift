//
//  ChartViewModelProtocol.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 08.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation
import RealmSwift

protocol ChartViewModelProtocol {
    var period: ChartPeriod { get set }
    var incomes: Results<Income>? { get set }
    var expenses: Results<Expense> { get set }
    var interval: DateInterval { get set }
    var category: Category? { get set }
}

enum ChartPeriod {
    case week
    case month
    case quarter
    case all
}

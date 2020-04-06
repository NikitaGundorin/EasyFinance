//
//  FormatHelper.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 04.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

class FormatHelper {
    static func getFormattedCurrency(value: Float) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = " "
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = ","
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2

        let result = numberFormatter.string(from: NSNumber(value: value))!
        return "\(result) ₽"
    }
    
    static func getFormattedDate(date: Date) -> String {
        let format = "dd.MM.yy"
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: date)
    }
}

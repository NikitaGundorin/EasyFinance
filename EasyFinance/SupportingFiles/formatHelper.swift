//
//  FormatHelper.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 04.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

class FormatHelper {
    static func formatCurrency(value: Float) -> String {
        return String(format: "%.2f ₽", value)
    }
}

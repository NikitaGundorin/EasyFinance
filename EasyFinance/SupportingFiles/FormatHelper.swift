//
//  FormatHelper.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 04.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import Foundation

class FormatHelper {
    static let supportingLanguages = ["en", "ru"]
    
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
    
    static func getFormattedDate(date: Date, short: Bool = false) -> String {
        let template = short ? "dd.MM" : "dd.MM.yy"
        let dateformat = DateFormatter()
        let localFormat = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: Locale.current)
        dateformat.dateFormat = localFormat
        return dateformat.string(from: date)
    }
    
    static func getLanguageCode() -> String {
        var locale: Locale
        if let preferredIdentifier = Locale.preferredLanguages.first {
            locale = Locale(identifier: preferredIdentifier)

        } else {
            locale = Locale.current
        }
        
        if let languageCode = locale.languageCode,
            supportingLanguages.contains(languageCode) {
            return languageCode
        }
        
        return "en"
    }
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.next,
                   weekday,
                   considerToday: considerToday)
    }
    
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.previous,
                   weekday,
                   considerToday: considerToday)
    }
    
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {
        
        let dayName = weekDay.rawValue
        
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1
        
        let calendar = Calendar(identifier: .gregorian)
        
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self.removeTimeStamp()
        }
        
        var nextDateComponent = calendar.dateComponents([], from: self)
        nextDateComponent.weekday = searchWeekdayIndex
        
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)
        
        return date!.removeTimeStamp()
    }
    
    func removeTimeStamp() -> Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
            fatalError("Failed to strip time from Date object")
        }
        return date
    }
    
    func startOfQuarter() -> Date {
        var components = Calendar.current.dateComponents([.month, .day, .year], from: self.startOfMonth())

        let newMonth: Int
        switch components.month! {
        case 1,2,3: newMonth = 1
        case 4,5,6: newMonth = 4
        case 7,8,9: newMonth = 7
        case 10,11,12: newMonth = 10
        default: newMonth = 1
        }
        components.month = newMonth
        return Calendar.current.date(from: components)!
    }
    
    func weekDay() -> Int {
        let week = Calendar.current.component(.weekday, from: self)
        return week == 1 ? 7 : week - 1
    }
    
    func currentDay() -> Int {
        return Calendar.current.component(.day, from: self)
    }
}

extension Date {
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }
    
    enum SearchDirection {
        case next
        case previous
        
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .next:
                return .forward
            case .previous:
                return .backward
            }
        }
    }
}

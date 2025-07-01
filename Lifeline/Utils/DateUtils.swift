//
//  DateUtils.swift
//  lifeline
//
//  Created by Malik Gohar on 28/06/2025.
//

import Foundation

extension Date {
    func startOfDay() -> Date {
        Calendar.current.startOfDay(for: self)
    }
    func endOfDay() -> Date {
        Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self) ?? self
    }
}


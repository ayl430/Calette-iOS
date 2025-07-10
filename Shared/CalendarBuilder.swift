//
//  CalendarBuilder.swift
//  JustCalendar
//
//  Created by yeri on 7/9/25.
//

import SwiftUI

struct CalendarDay: Identifiable {
    let id = UUID()
    let date: Date
    let isInCurrentMonth: Bool
    let hasEvent: Bool
}

struct CalendarMonth {
    let days: [CalendarDay]
    let startDate: Date
//    let lines: Int
}

struct CalendarBuilder {
    
    /// 앞 뒤 패딩을 포함한 달력에 표시할 전체 날짜
    ///
    /// (2025-07 -> 06/29 - 08/02)
    ///
    /// - for: 기준이 될 날짜
    /// - firstWeekday: 1이면 일요일 시작, 2면 월요일 시작
    static func generateMonth(for baseDate: Date, events: Set<Int> = []) -> [CalendarDay]? {
        let calendar = Calendar.current
        let firstDayOfMonth = baseDate.startOfMonth
        guard let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth) else { return nil }
        
        let weekday = calendar.component(.weekday, from: firstDayOfMonth) // 일1 ~ 토7
//        let firstDayOfWeek = WidgetSettingsManager.shared.firstDayOfWeek
        let firstDayOfWeek = WidgetSettingModel().firstDayOfWeek
        let leadingEmpty = (weekday - firstDayOfWeek + 7) % 7
        
        guard let startDate = calendar.date(byAdding: .day, value: -leadingEmpty, to: firstDayOfMonth) else { return nil }
        
        // leading + daysInMonth + trailing
        let totalDays = leadingEmpty + range.count
        let paddedCount = (totalDays % 7 == 0) ? totalDays : totalDays + (7 - totalDays % 7)
        
        return (0..<paddedCount).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: startDate) else { return nil }
            
            let isCurrentMonth = calendar.isDate(date, equalTo: baseDate, toGranularity: .month)
            let day = calendar.component(.day, from: date)
            let hasEvent = isCurrentMonth && events.contains(day)
            
            return CalendarDay(date: date, isInCurrentMonth: isCurrentMonth, hasEvent: hasEvent)
        }
    }
}

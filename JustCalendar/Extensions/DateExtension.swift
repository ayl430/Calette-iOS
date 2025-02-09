//
//  DateExtension.swift
//  JustCalendar
//
//  Created by yeri on 2/2/25.
//

import Foundation

extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "ko_KR")
        return formatter.string(from: self)
    }
    
    func toStringDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        formatter.timeZone = TimeZone(identifier: "ko_KR")
        return formatter.string(from: self)
    }
    
//    func dayOfWeek() -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "EEEE"
//        return formatter.string(from: self).capitalized
//    }
    
//    var startOfMonth: Date {
//        let start = Calendar.current.startOfDay(for: self)
//        return start
//    }
    
    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: components)!
    }
    
    var endOfMonth: Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth)!
    }
    
    var dayOfWeekFirst: Int { // 해당 월 1일의 요일 (1-일, 7-토)
        return Calendar.current.dateComponents([.weekday], from: self.startOfMonth).weekday ?? 0
    }
    
    var dayOfweekLast: Int {
        return Calendar.current.dateComponents([.weekday], from: self.endOfMonth).weekday ?? 0
    }
    
    var priorMonth: Date {
        return Calendar.current.date(byAdding: DateComponents(month: -1), to: self)!
    }
    
    var nextMonth: Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1), to: self)!
    }
    
    func getDay() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        let endOfMonthInt = Calendar.current.component(.day, from: self)
        
        return endOfMonthInt
    }
    
    func getDays() -> [Int] {
        var daysOfCalendar = [Int]()
        
        // 이달의 마지막 날
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        let endOfMonth = self.endOfMonth
        let endOfMonthInt = Calendar.current.component(.day, from: endOfMonth)
        let rangeOfMonth = 1...endOfMonthInt
        rangeOfMonth.forEach { daysOfCalendar.append($0) }
        
        return daysOfCalendar
    }
    
    func getFiveLinesDays() -> [Int] {
        var daysOfCalendar = [Int]()
        
        // 이달의 마지막 날
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        let endOfMonth = self.endOfMonth
        let endOfMonthInt = Calendar.current.component(.day, from: endOfMonth)
        let rangeOfMonth = 1...endOfMonthInt
        rangeOfMonth.forEach { daysOfCalendar.append($0) }
        
        // 이전 달의 표시
        let addPriorDay = endOfMonth.dayOfWeekFirst - 1
        if addPriorDay != 0 {
            let lastDayOfPriorMonth = self.priorMonth.endOfMonth
            let lastDayOfPriorMonthInt = Calendar.current.component(.day, from: lastDayOfPriorMonth)
            
            let firstDayOfCalendar = Calendar.current.date(byAdding: DateComponents(day: -(endOfMonth.dayOfWeekFirst - 1)), to: lastDayOfPriorMonth)!
            let firstDayOfCalendarInt = Calendar.current.component(.day, from: firstDayOfCalendar)
            
            for i in 0...(addPriorDay - 1) {
                daysOfCalendar.insert(lastDayOfPriorMonthInt - i, at: 0)
            }
        }
        
        // 다음 달 표시
        let addNextDay = 7 - endOfMonth.dayOfweekLast
        if addNextDay > 0 {
            for i in 0...(addNextDay - 1) {
                daysOfCalendar.append(i + 1)
            }
        }
        
        
        return daysOfCalendar
    }
    
    func get(component: Calendar.Component) -> Int {
        let date = Calendar.current.dateComponents([.year, .month, .day, .weekday], from: self)
        var value = 0
        
        switch component {
        case .year:
            value = date.year ?? 0
            case .month:
            value = date.month ?? 0
        case .day:
            value = date.day ?? 0
        case .weekday:
            value = date.weekday ?? 0
        default:
            value = 0
        }
        
        return value
    }
    
    func delta(from date: Date) -> Int {
        let delta = date.timeIntervalSince(self) // 뒤 날짜 - self 날짜
        let day = delta / 86400
        return Int(day)
    }
}

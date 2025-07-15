//
//  DateExtension.swift
//  JustCalendar
//
//  Created by yeri on 2/2/25.
//

import Foundation
import KoreanLunarSolarConverter

extension Date {
    
    // 2025-07-12 17:10:56 +0000 -> "2025-07-13" (GMT -> 로컬)
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "ko_KR")
        return formatter.string(from: self)
    }
    
    func toStringMdd() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M.d"
        formatter.timeZone = TimeZone(identifier: "ko_KR")
        return formatter.string(from: self)
    }
    
    /// 해당 날짜 달의 시작 (로컬 달력 기준 해당 날짜 달의 1일 - 값은 GMT)
    var startOfMonth: Date { // -> firstDayOfMonth
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: components)!
    }
    
    var endOfMonth: Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth)!
    }
    
    var priorMonth: Date {
        return Calendar.current.date(byAdding: DateComponents(month: -1), to: self)!
    }
    
    var nextMonth: Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1), to: self)!
    }
    
    var lunarDate: Date {
        let converter  = KoreanSolarToLunarConverter()
        let lunarDate = try? converter.lunarDate(fromSolar: self)
        
        return lunarDate?.date ?? self
    }
    
    /// 해당 날짜의 로컬 날짜
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
    
    // Date() -> 2025-07-15 12:39:40 +0000
    // Date().local -> 2025-07-15 21:39:40 +0000
    /// 해당 날짜의 로컬 날짜와 시간 (서울)
    var local: Date {
        let timezone = TimeZone(identifier: "Asia/Seoul")
        let secondsFromGMT = timezone!.secondsFromGMT(for: self)
        let localizedDate = self.addingTimeInterval(TimeInterval(secondsFromGMT))
        
        return localizedDate
    }
    
    // 2025-07-14 15:00:00 +0000
    /// 해당 날짜의 시작 (로컬 달력 기준, 해당 날짜의 00시 - 값은 GMT)
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    // 2025-07-15 15:00:00 +0000
    /// 해당 날짜의 끝 (로컬 달력 기준, 해당 날짜의 다음 날 00시 - 값은 GMT)
    var lastOfDay: Date {
        var components = DateComponents()
        components.day = 1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
            .addingTimeInterval(-0.0000000000000001)
    }
}

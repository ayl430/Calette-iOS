//
//  DateExtension.swift
//  Calette
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
    
    func toGMTString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: self)
    }

    func toStringMdd() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M.d"
        formatter.timeZone = TimeZone(identifier: "ko_KR")
        return formatter.string(from: self)
    }
    
    func toStringD() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        formatter.timeZone = TimeZone(identifier: "ko_KR")
        return formatter.string(from: self)
    }
    
    func toStringAhmm() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h:mm"
        return formatter.string(from: self)
    }
    
    func toStringEEE() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "EEE"
        return formatter.string(from: self)
    }
    
    /// 해당 날짜 달의 시작 (로컬 달력 기준 해당 날짜 달의 1일 - 값은 GMT)
    var startOfMonth: Date { // -> firstDayOfMonth
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: components)!
    }
    
    var endOfMonth: Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1), to: self.startOfMonth)!
    }
    
    var priorMonth: Date {
        return Calendar.current.date(byAdding: DateComponents(month: -1), to: self)!
    }

    var nextMonth: Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1), to: self)!
    }

    /// 하루 전 (월·연·윤년·DST 안전)
    var priorDay: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self) ?? self
    }

    /// 하루 후 (월·연·윤년·DST 안전)
    var nextDay: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self) ?? self
    }
    
    var lunarDate: Date {
        guard let converter = try? KoreanSolarToLunarConverter(),
              let lunar = try? converter.lunarDate(fromSolar: self),
              let date = Calendar.current.date(from: DateComponents(year: lunar.year, month: lunar.month, day: lunar.day))
        else { return self }
        return date
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
    
    var isThisMonth: Bool {
        return self.startOfMonth == Date().startOfMonth ? true : false
    }

    // MARK: - 주/월 범위 계산 (scope 필터링용)

    /// 해당 날짜가 포함된 주의 시작일 (startOfDay)
    /// - Parameter firstWeekday: 1이면 일요일 시작, 2면 월요일 시작
    func startOfWeek(firstWeekday: Int = 1) -> Date {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self) // 1(일) ~ 7(토)
        let offset = (weekday - firstWeekday + 7) % 7
        return calendar.date(byAdding: .day, value: -offset, to: self.startOfDay) ?? self.startOfDay
    }

    /// 해당 날짜가 포함된 주의 종료 시각 (다음 주 시작 - 1 epsilon)
    func lastOfWeek(firstWeekday: Int = 1) -> Date {
        let start = startOfWeek(firstWeekday: firstWeekday)
        let nextWeekStart = Calendar.current.date(byAdding: .day, value: 7, to: start) ?? start
        return nextWeekStart.addingTimeInterval(-0.0000000000000001)
    }

    /// 해당 날짜가 포함된 주의 7개 날짜 (각 날짜의 startOfDay)
    func datesInWeek(firstWeekday: Int = 1) -> [Date] {
        let start = startOfWeek(firstWeekday: firstWeekday)
        let calendar = Calendar.current
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: start) }
    }

    /// 해당 날짜가 포함된 달의 모든 날짜 (각 날짜의 startOfDay)
    var datesInMonth: [Date] {
        let calendar = Calendar.current
        let start = startOfMonth
        guard let range = calendar.range(of: .day, in: .month, for: start) else { return [start] }
        return (0..<range.count).compactMap { calendar.date(byAdding: .day, value: $0, to: start) }
    }

    /// 동일 날짜 여부 (로컬 달력 기준)
    func isSameDay(as other: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: other)
    }
}

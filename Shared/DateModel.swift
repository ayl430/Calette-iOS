//
//  DateModel.swift
//  JustCalendar
//
//  Created by yeri on 2/5/25.
//

import Foundation
import SwiftUI

class DateModel: ObservableObject {
    
    static let shared = DateModel()
    
    @Published var selectedDate: Date = Date()
    @Published var eventDays: [Date] = []
    
    private init() {
        setEvent()
    }
    
    func setThisMonth() {
        DispatchQueue.main.async {
            self.selectedDate = Date()
            self.setEvent()
        }
    }
    
    func setPriorMonth() {
        DispatchQueue.main.async {
            self.selectedDate = self.selectedDate.priorMonth.startOfMonth
            self.setEvent()
        }
    }
    
    func setNextMonth() {
        DispatchQueue.main.async {
            self.selectedDate = self.selectedDate.nextMonth.startOfMonth
            self.setEvent()
        }
    }
    
    func setEvent() {
        DispatchQueue.main.async {
            if EventManager.shared.isFullAccess {
                guard let days = EventManager.shared.fetchAllEventsThisMonth(date: self.selectedDate) else { return }
                self.eventDays = days
            }
        }
    }
    
    func hasEvent(on date: Date) -> Bool {
        if eventDays.contains(where: { $0.startOfDay == date.startOfDay }) {
            return true
        }
        return false
    }
    
    func isHoliday(on date: Date) -> Bool {        
        if let holidays = EventManager.shared.fetchHolidayEventDates(date: date) {
            if holidays.contains(where: { $0.startOfDay == date.startOfDay }) {
                return true
            }
            return false
        }
        return false
    }
    
    /// 최대로 만들 수 있는 event title view의 수
    func maxEventTitleViewLines() -> Int {
        guard let thisMonthDays = CalendarBuilder.generateMonth(for: selectedDate) else { return 0 }
        
        let thisMonthDaysLines = thisMonthDays.count / 7
        
        let num: Int
        switch thisMonthDaysLines {
        case 4:
            num = 3
        case 5:
            num = 2
        case 6:
            num = 1
        default:
            num = 1
        }
        return num
    }
}

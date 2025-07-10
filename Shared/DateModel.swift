//
//  DateModel.swift
//  JustCalendar
//
//  Created by yeri on 2/5/25.
//

import Foundation
import SwiftUI

class DateModel: ObservableObject {//ViewModel
    
    static let shared = DateModel()
    
    @Published var selectedDate: Date = Date()
    @Published var events: [EventItem?] = []
    
    private init() {
        setEvent()
    }
    
    func setThisMonth() {
        selectedDate = Date()
        setEvent()
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
    
    private func setEvent() {
        if EventManager.shared.isFullAccess {
            events = EventManager.shared.fetchEventsDays(date: selectedDate)
        }
    }
    
    func hasEvent(on date: Date) -> Bool {
        if let _ = events.first(where: { ($0?.date?.startOfDay) == date.startOfDay }) {
            return true
        }
        return false
        
    }
    
    func isHoliday(on date: Date) -> Bool {
        if let event = events.first(where: { ($0?.date) == date }) {
            if event?.calendarTitle == "대한민국 공휴일", event?.calendarType == .subscription, ((event?.allowModification!) == false) {
                return true
            }
            return false
        }
        return false
    }
    
    /// 최대로 만들 수 있는 event detail view의 수
    ///
    /// - for: 기준이 될 날짜
    /// - firstWeekday: 1이면 일요일 시작, 2면 월요일 시작
    func maxEventDetailViewLines() -> Int {        
        guard let thisMonthDays = CalendarBuilder.generateMonth(for: selectedDate) else { return 0 }
        
        let thisMonthDaysLines = thisMonthDays.count / 7
        return thisMonthDaysLines == 6 ? 1 : 2
    }
}

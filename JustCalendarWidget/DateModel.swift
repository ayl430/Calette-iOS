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
    
    @Published var selectedDate: Date = Date() // 처음엔 '오늘', 이전/이후 버튼 누르고 '1일', 날짜 누르고 '해당 날짜' -> 변수 수정 'selectedDate'?
    @Published var events: [EventItem?] = []
    
    private init() {
        setEvent()
    }
    
    func setThisMonth() {
        selectedDate = Date()
        setEvent()
    }
    
    func setPriorMonth() {
        selectedDate = selectedDate.priorMonth.startOfMonth
        setEvent()
    }
    
    func setNextMonth() {
        selectedDate = selectedDate.nextMonth.startOfMonth
        setEvent()
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
    
    func totalLines() -> Int {
        let zeroToLastDay = (selectedDate.dayOfWeekFirst - WidgetSettingsManager.shared.firstDayOfWeek) + selectedDate.getDays().count
        let lines = zeroToLastDay / 7 + (zeroToLastDay % 7 > 0 ? 1 : 0)
        return lines
    }
    
    func maxEvents() -> Int {
//        let zeroToLastDay = (selectedDate.dayOfWeekFirst - WidgetSettingsManager.shared.firstDayOfWeek) + selectedDate.getDays().count
//        let lines = zeroToLastDay / 7 + (zeroToLastDay % 7 > 0 ? 1 : 0)
        let lines = totalLines()
        if lines == 6 {
            return 1
        } else {
            return 2
        }
    }
}

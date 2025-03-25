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
    
    func hasEvent(on date: Int) -> Bool {
        if let _ = events.first(where: { ($0?.date?.getDay()) == date }) {
            return true
        }
        return false
        
    }
    
    func hasMultipleEvents() -> Bool {
        return events.count >= 2 ? true : false
    }
    
    func isHoliday(on date: Int) -> Bool {
        if let event = events.first(where: { ($0?.date?.getDay()) == date }) {
            if event?.calendarTitle == "대한민국 공휴일", event?.calendarType == .subscription, ((event?.allowModification!) == false) {
                return true
            }
            return false
        }
        return false
    }
}

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
    
    @Published var today: Date = Date() // 처음엔 '오늘', 이전/이후 버튼 누르고 '1일', 날짜 누르고 '해당 날짜'
    @Published var events: [EventList?] = []
    
    private init() {
        setEvent()
    }
    
    func setPriorMonth() {
        today = today.priorMonth.startOfMonth
        setEvent()
    }
    
    func setNextMonth() {
        today = today.nextMonth.startOfMonth
        setEvent()
    }
    
    private func setEvent() {
        if EventManager.shared.isFullAccess {
            events = EventManager.shared.fetchEventsDays(date: today)
        }
    }
    
    func hasEvent(on date: String) -> Bool {
        var hasEvent: Bool = false
        if let dateInt = Int(date) {
            events.forEach {
                let eventDateInt = Int(($0?.date?.toStringDay())!)
                if let eventDateInt = eventDateInt, eventDateInt <= dateInt {
                    hasEvent = eventDateInt == dateInt
                }
            }
            return hasEvent
        }
        return hasEvent
    }
    
}

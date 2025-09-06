//
//  DateViewModel.swift
//  Calette
//
//  Created by yeri on 2/5/25.
//

import Foundation
import SwiftUI

class DateViewModel: ObservableObject {
    
    @AppStorage(SharedSettings.Keys.selectedDateKey, store: UserDefaults.shared) var storedSelectedDate: String = Date().toGMTString()
    var selectedDate: Date {
        set {
            storedSelectedDate = newValue.toGMTString()
            self.setEvent()
        }
        get {
            #if WIDGET
            if let date = storedSelectedDate.toGMTDate() {
                return date.isThisMnoth ? date : Date()
            }
            return Date()
            #else
            return storedSelectedDate.toGMTDate() ?? Date()
            #endif
        }
    }
    
    @Published var eventDays: [Date] = []
    
    init() {
        setEvent()
    }
    
    func setThisMonth() {
        DispatchQueue.main.async {
            self.selectedDate = Date()
        }
    }
    
    func setPriorMonth() {
        DispatchQueue.main.async {
            self.selectedDate = self.selectedDate.priorMonth.startOfMonth
        }
    }
    
    func setNextMonth() {
        DispatchQueue.main.async {
            self.selectedDate = self.selectedDate.nextMonth.startOfMonth
        }
    }
    
    func setSelectedDate(date: Date) {
        DispatchQueue.main.async {
            self.selectedDate = date
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

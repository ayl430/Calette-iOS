//
//  DateViewModel.swift
//  Calette
//
//  Created by yeri on 2/5/25.
//

import Foundation
import SwiftUI

class DateViewModel: ObservableObject {
    
    @AppStorage(DefaultsKeys.Shared.selectedDateKey, store: UserDefaults.shared) var storedSelectedDate: String = Date().toGMTString()
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
}

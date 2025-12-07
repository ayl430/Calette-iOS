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
    @AppStorage(DefaultsKeys.Shared.lastSelectionTimeKey, store: UserDefaults.shared) var lastSelectionTime: Double = Date().timeIntervalSince1970
    
    static let resetInterval: TimeInterval = 600 // 600s
    
    var selectedDate: Date {
        set {
            storedSelectedDate = newValue.toGMTString()
            lastSelectionTime = Date().timeIntervalSince1970
            self.setEvent()
        }
        get {
            if shouldResetToToday() {
                return Date()
            }
            return storedSelectedDate.toGMTDate() ?? Date()
        }
    }
    
    @Published var eventDays: [Date] = []
    
    init() {
        checkAndResetIfNeeded()
        setEvent()
    }
    
    // MARK: - 일정 시간 경과 후 리셋 (오늘 날짜로)
    
    enum ResetContext {
        case app
        case widget
        
        var description: String {
            switch self {
            case .app: return "App"
            case .widget: return "Widget"
            }
        }
    }
    
    func shouldReset(context: ResetContext) -> Bool {
        // 1. 일정 시간 경과했는지 체크
        if shouldResetToToday() {
            print("[\(context.description)] 리셋 실행: (\(Self.resetInterval)s) 경과")
            return true
        }
        
        // 2. 다른 달인지 체크
        guard let date = storedSelectedDate.toGMTDate() else {
            print("[\(context.description)] 리셋 실행: 날짜 오류")
            return true
        }
        
        if !date.isThisMonth {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            print("[\(context.description)] 리셋 실행: 다른 달 선택됨 (저장된 날짜: \(dateFormatter.string(from: date)), 현재: \(dateFormatter.string(from: Date())))")
            return true
        }
        
        print("[\(context.description)] 리셋 불 필요")
        return false
    }
    
    func resetToToday() {
        DispatchQueue.main.async {
            self.storedSelectedDate = Date().toGMTString()
            self.lastSelectionTime = Date().timeIntervalSince1970
            self.objectWillChange.send()
            print("리셋 완료: 오늘 날짜로 변경")
        }
    }
    
    func checkAndResetIfNeeded() {
        if shouldReset(context: .app) {
            resetToToday()
        }
    }
    
    // 다음 리셋 예정 시간 - 위젯 timeline
    var nextResetDate: Date {
        let lastSelection = Date(timeIntervalSince1970: lastSelectionTime)
        return lastSelection.addingTimeInterval(Self.resetInterval)
    }
    
    // 마지막 선택 후 일정 시간이 지났는지 확인
    private func shouldResetToToday() -> Bool {
        let lastSelection = Date(timeIntervalSince1970: lastSelectionTime)
        let timePassed = Date().timeIntervalSince(lastSelection)
        return timePassed >= Self.resetInterval
    }
    
    // MARK: - 날짜 선택 (버튼)
    
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

//
//  EventManager.swift
//  JustCalendar
//
//  Created by yeri on 2/6/25.
//

import Foundation
import EventKit
import EventKitUI

class EventManager: NSObject {
    static let shared = EventManager()
    
    override private init() {
        super.init()
    }
    
    let eventStore = EKEventStore()
    
    var isFullAccess: Bool {
        EKEventStore.authorizationStatus(for: .event) == .fullAccess
    }
    
    func requestFullAccess() async throws -> Bool {
        return try await eventStore.requestFullAccessToEvents()
    }
    
    func fetchEvents() -> [EKEvent] {
        guard isFullAccess else { return [] }
        let start = Date().startOfMonth
        let end = Date().endOfMonth
        print("start: \(start)")
        print("end: \(end)")
        let predicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: nil)
        return eventStore.events(matching: predicate).sortedEventByAscendingDate()
    }
    
    func fetchEventsString() {
        guard isFullAccess else { return }
        let start = Date().startOfMonth
        let end = Date().endOfMonth
        print("start: \(start)")
        print("end: \(end)")
        let predicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: nil)
        let events = eventStore.events(matching: predicate).sortedEventByAscendingDate()
        
        var eventNames: [String] = []
        events.forEach {
            eventNames.append($0.title)
        }
        print(eventNames)
    }
    
    func fetchEventsDays(date: Date) -> [EventList] {
        guard isFullAccess else { return [EventList]() }
        let start = date.startOfMonth
        let end = date.endOfMonth
        print("start: \(start)")
        print("end: \(end)")
        let predicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: nil)
        let events =  eventStore.events(matching: predicate).sortedEventByAscendingDate()
        
        var eventList: [EventList] = []
        events.forEach {
            let startDate = $0.startDate
            let endDate = $0.endDate
            let title = $0.title
            
            var addDate = startDate!
            
            repeat {
                let value = EventList(title: title!, date: addDate)
                eventList.append(value)
                addDate = addDate.addingTimeInterval(86400)
            } while addDate <= endDate!
            
        }
        print("fetchEventsDays: \(eventList)")
        return eventList
    }
}


extension Date {
    // 현재날짜 + 1달
    var oneMonthOut: Date {
        Calendar.current.date(byAdding: .month, value: 1, to: Date.now) ?? Date()
    }
    
    var firstDayOfMonth: Date {
//        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        Calendar.current.date(byAdding: DateComponents(month: -1, day: 1), to: self)!
    }
}

extension Array {
    // 캘린더 이벤트를 오름차순으로 배열
    func sortedEventByAscendingDate() -> [EKEvent] {
        guard let self = self as? [EKEvent] else { return [] }
        
        return self.sorted(by: { (first: EKEvent, second: EKEvent) in
            return first.compareStartDate(with: second) == .orderedAscending
        })
    }
}

struct EventList {
    let title: String?
    let date: Date?
}

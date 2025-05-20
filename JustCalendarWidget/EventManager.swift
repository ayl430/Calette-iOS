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
        
        let predicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: nil)
        return eventStore.events(matching: predicate).sortedEventByAscendingDate()
    }
    
    func fetchEventsString() {
        guard isFullAccess else { return }
        let start = Date().startOfMonth
        let end = Date().endOfMonth
        
        let predicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: nil)
        let events = eventStore.events(matching: predicate).sortedEventByAscendingDate()
        
        var eventNames: [String] = []
        events.forEach {
            eventNames.append($0.title)
        }
        print(eventNames)
    }
    
    //date를 포함한 달의 모든 evnets
    func fetchEventsDays(date: Date) -> [EventItem] {
        guard isFullAccess else { return [EventItem]() }
        let start = date.startOfMonth
        let end = date.endOfMonth
        let predicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: nil)
        let events =  eventStore.events(matching: predicate).sortedEventByAscendingDate()
        
        var eventList: [EventItem] = []
        events.forEach {
            let startDate = $0.startDate
            let endDate = $0.endDate
            let title = $0.title
            
            let calendarTitle = $0.calendar.title
            let calendarType = $0.calendar.type
            let allowModification = $0.calendar.allowsContentModifications
            
            var addDate = startDate!
            repeat {
                let value = EventItem(title: title!, date: addDate, calendarTitle: calendarTitle, calendarType: calendarType, allowModification: allowModification)
                eventList.append(value)
                addDate = addDate.addingTimeInterval(86400)
            } while addDate <= endDate!
            
        }
//        eventList.forEach { print($0) }
        return eventList
    }
    
    // 특정 날의 이벤트
    func fetchEvents(on date: Date) -> [EventItem] {        
        let allEvents = getEvents(date: date)
        let events = allEvents.filter { $0.date?.local.startOfDay == date.startOfDay }
        return events
    }    
    
    // date의 모든 이벤트
    func getEvents(date: Date) -> [EventItem] {
        guard isFullAccess else { return [EventItem]() }
        
        let predicate = eventStore.predicateForEvents(withStart: date.startOfDay, end: date.lastOfDay, calendars: nil)
        let events =  eventStore.events(matching: predicate).sortedEventByAscendingDate()
        
        var eventList: [EventItem] = []
        events.forEach {
            let title = $0.title
            
            let calendarTitle = $0.calendar.title
            let calendarType = $0.calendar.type
            let allowModification = $0.calendar.allowsContentModifications
            
            let value = EventItem(title: title!, date: date, calendarTitle: calendarTitle, calendarType: calendarType, allowModification: allowModification)
            eventList.append(value)
        }
        return eventList
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

struct EventItem {
    let title: String?
    let date: Date?
    
    let calendarTitle: String?
    let calendarType: EKCalendarType?
    let allowModification: Bool?
}

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
    
    //date를 포함한 달의 모든 events
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
    
    // date를 포함한 달에 이벤트가 있는 dates - 공휴일 -> set으로 받기
    func fetchHolidayEventDates(date: Date) -> [Date]? {
        guard isFullAccess else { return nil }
        let start = date.startOfMonth
        let end = date.endOfMonth
        let holidayCalendars = eventStore.calendars(for: .event).filter {
            $0.title.contains("공휴일") || $0.title.lowercased().contains("holiday")
        }
        
        let predicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: holidayCalendars)
        let events = eventStore.events(matching: predicate)
        
        return events.map { $0.startDate }
    }
    
    // date룰 포함한 달에 이벤트가 있는 dates - 일반 이벤트
    func fetchEventDates(date: Date) -> [Date]? {
        guard isFullAccess else { return nil }
        let start = date.startOfMonth
        let end = date.endOfMonth
        let calendars = eventStore.calendars(for: .event)
        let holidayCalendars = calendars.filter {
            $0.title.contains("공휴일") || $0.title.lowercased().contains("holiday")
        }
        let nonHolidayCalendars = calendars.filter { !holidayCalendars.contains($0) }
        
        let predicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: nonHolidayCalendars)
        let events = eventStore.events(matching: predicate)
        
        return events.map { $0.startDate }
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

struct EventItem {
    let title: String?
    let date: Date?
    
    let calendarTitle: String?
    let calendarType: EKCalendarType?
    let allowModification: Bool?
}

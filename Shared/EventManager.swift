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
    
    /// date의 모든 이벤트 (EKEvent)
    func fetchAllEvents(date: Date) -> [EKEvent] {
        guard isFullAccess else { return [EKEvent]() }
        
        let start = date.startOfDay
        let end = date.lastOfDay
        let calendars = eventStore.calendars(for: .event)
        let predicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: calendars)
        let events = eventStore.events(matching: predicate)
        
        return events
    }
    
    /// date의 모든 이벤트 (EventItem)
    func fetchAllEventItems(date: Date) -> [EventItem] {
        guard isFullAccess else { return [EventItem]() }
        
        let events: [EKEvent] = fetchAllEvents(date: date)
        var eventList = [EventItem]()
        events.forEach {
            let title = $0.title
            let startDate = $0.startDate
            
            let calendarTitle = $0.calendar.title
            let calendarType = $0.calendar.type
            let allowModification = $0.calendar.allowsContentModifications
            
            let value = EventItem(title: title!, date: startDate, calendarTitle: calendarTitle, calendarType: calendarType, allowModification: allowModification)
            eventList.append(value)
        }
        return eventList
    }
    
    /// date의 모든 공휴일 (EKEvent)
    func fetchAllHolidays(on date: Date) -> [EKEvent] {
        guard isFullAccess else { return [EKEvent]() }
        
        let start = date.startOfDay
        let end = date.lastOfDay
        let holidayCalendars = eventStore.calendars(for: .event).filter {
            $0.title.contains("공휴일") || $0.title.lowercased().contains("holiday")
        }
        
        let predicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: holidayCalendars)
        let events = eventStore.events(matching: predicate)
        
        return events
    }
    
    /// date의 공휴일을 제외한 모든 이벤트 (EKEvent)
    func fetchAllNormalEvents(on date: Date) -> [EKEvent] {
        guard isFullAccess else { return [EKEvent]() }
        
        let start = date.startOfDay
        let end = date.lastOfDay
        let holidayCalendars = eventStore.calendars(for: .event).filter {
            !$0.title.contains("공휴일") && !$0.title.lowercased().contains("holiday")
        }
        
        let predicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: holidayCalendars)
        let events = eventStore.events(matching: predicate)
        
        return events
    }
    
    // date를 포함한 달에 이벤트가 있는 dates
    func fetchAllEventsThisMonth(date: Date) -> [Date]? {
        guard isFullAccess else { return nil }
        
        let start = date.startOfMonth
        let end = date.endOfMonth
        let calendars = eventStore.calendars(for: .event)
        let predicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: calendars)
        let events = eventStore.events(matching: predicate)
        
        return events.map { $0.startDate }
    }
    
    // date를 포함한 달에 이벤트가 있는 dates - 공휴일 -> set으로 받기
    func fetchHolidayEventDates(date: Date) -> [Date]? {
        guard isFullAccess else { return nil }
        
        let start = date.startOfMonth
        let end = date.endOfMonth
        let holidayCalendars = eventStore.calendars(for: .event).filter {
            $0.title.contains("공휴일") || $0.title.lowercased().contains("holiday") //if event?.calendarTitle == "대한민국 공휴일", event?.calendarType == .subscription, ((event?.allowModification!) == false) {
        }
        
        let predicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: holidayCalendars)
        let events = eventStore.events(matching: predicate)
        
        return events.map { $0.startDate }
    }
    
//    // date룰 포함한 달에 이벤트가 있는 dates - 일반 이벤트
//    func fetchEventDates(date: Date) -> [Date]? {
//        guard isFullAccess else { return nil }
//        let start = date.startOfMonth
//        let end = date.endOfMonth
//        let calendars = eventStore.calendars(for: .event)
//        let holidayCalendars = calendars.filter {
//            $0.title.contains("공휴일") || $0.title.lowercased().contains("holiday")
//        }
//        let nonHolidayCalendars = calendars.filter { !holidayCalendars.contains($0) }
//        
//        let predicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: nonHolidayCalendars)
//        let events = eventStore.events(matching: predicate)
//        
//        return events.map { $0.startDate }
//    }
    
    func fetchEvent(withId eventId: String) -> EKEvent? {
        guard isFullAccess else { return EKEvent() }
        
        if let event = eventStore.event(withIdentifier: eventId) {
            return event
        } else {
            print("이벤트 \(eventId) 없음")
            return nil
        }
    }
    
    func deleteEvent(withId eventId: String) {
        guard isFullAccess else { return }
        
        if let eventToDelete = eventStore.event(withIdentifier: eventId) {
            do {
                try eventStore.remove(eventToDelete, span: .thisEvent)
                print("이벤트 삭제")
            } catch {
                print("이벤트 삭제 오류: \(error.localizedDescription)")
            }
        } else {
            print("이벤트 \(eventId) 없음")
        }
    }
    
}

class EKEventManager: ObservableObject {
    let eventStore = EKEventStore()
}

struct EventItem {
    let title: String?
    let date: Date?
    
    let calendarTitle: String?
    let calendarType: EKCalendarType?
    let allowModification: Bool?
}

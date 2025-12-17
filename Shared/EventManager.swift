//
//  EventManager.swift
//  Calette
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
        let nonHolidayCalendars = eventStore.calendars(for: .event).filter {
            !$0.title.contains("공휴일") && !$0.title.lowercased().contains("holiday")
        }
        
        let predicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: nonHolidayCalendars)
        let events = eventStore.events(matching: predicate)
        
        return events
    }
    
    // date를 포함한 달에 이벤트가 있는 dates
    func fetchAllEventsThisMonth(date: Date) -> [Date]? {
        guard isFullAccess else { return nil }

        let calendar = Calendar.current
        let monthStart = date.startOfMonth
        let monthEnd = date.endOfMonth
        let calendars = eventStore.calendars(for: .event)
        let predicate = eventStore.predicateForEvents(withStart: monthStart, end: monthEnd, calendars: calendars)
        let events = eventStore.events(matching: predicate)

        var eventDates: [Date] = []

        for event in events {
            // 이벤트의 시작일부터 종료일까지 모든 날짜 추가
            var currentDate = event.startDate.startOfDay
            let eventEndDate = event.endDate.startOfDay

            while currentDate <= eventEndDate {
                // 해당 월에 속하는 날짜만 추가
                if currentDate >= monthStart && currentDate <= monthEnd {
                    eventDates.append(currentDate)
                }
                guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
                currentDate = nextDate
            }
        }

        return eventDates
    }
    
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
    
    func isHoliday(_ date: Date) -> Bool {
        let holidaysOnDate = fetchAllHolidays(on: date)
        let count = holidaysOnDate.count
        return count > 0
    }
    
    func hasEvent(_ date: Date) -> Bool {
        let eventsOnDate = fetchAllEvents(date: date)
        let count = eventsOnDate.count
        return count > 0
    }

    // MARK: - 위젯 only

    /// 월별 날짜별 이벤트 정보를 한 번에 조회
    func fetchMonthEventInfos(for date: Date) -> [String: (eventCount: Int, isHoliday: Bool, events: [(title: String, isHoliday: Bool)])] {
        guard isFullAccess else { return [:] }

        let calendar = Calendar.current
        let monthStart = date.startOfMonth
        let monthEnd = date.endOfMonth
        let calendars = eventStore.calendars(for: .event)
        let predicate = eventStore.predicateForEvents(withStart: monthStart, end: monthEnd, calendars: calendars)
        let events = eventStore.events(matching: predicate)

        var result: [String: (eventCount: Int, isHoliday: Bool, events: [(title: String, isHoliday: Bool)])] = [:]

        for event in events {
            let isHolidayCalendar = event.calendar.title.contains("공휴일") || event.calendar.title.lowercased().contains("holiday")
            let eventInfo = (title: event.title ?? "", isHoliday: isHolidayCalendar)

            // 이벤트의 시작일부터 종료일까지 모든 날짜에 추가
            var currentDate = event.startDate.startOfDay
            let eventEndDate = event.endDate.startOfDay

            while currentDate <= eventEndDate {
                // 해당 월에 속하는 날짜만 추가
                if currentDate >= monthStart && currentDate <= monthEnd {
                    let dateKey = currentDate.toString()

                    if var existing = result[dateKey] {
                        existing.eventCount += 1
                        if isHolidayCalendar {
                            existing.isHoliday = true
                        }
                        existing.events.append(eventInfo)
                        result[dateKey] = existing
                    } else {
                        result[dateKey] = (eventCount: 1, isHoliday: isHolidayCalendar, events: [eventInfo])
                    }
                }
                guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
                currentDate = nextDate
            }
        }

        return result
    }
}

class EKEventManager: ObservableObject {
    let eventStore = EKEventStore()
}

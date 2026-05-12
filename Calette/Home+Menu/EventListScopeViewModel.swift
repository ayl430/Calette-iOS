//
//  EventListScopeViewModel.swift
//  Calette
//
//  날짜 상세 페이지의 일/주/월 scope 상태와 grouped 이벤트를 관리.
//

import Foundation
import EventKit
import SwiftUI

// MARK: - Scope 모델

enum EventListScope: String, CaseIterable, Identifiable {
    case day
    case week
    case month

    var id: String { rawValue }

    var title: String {
        switch self {
        case .day: return "일"
        case .week: return "주"
        case .month: return "월"
        }
    }
}

// MARK: - Day section 모델

struct EventDaySection: Identifiable, Equatable {
    let date: Date
    let holidays: [EKEvent]
    let normalEvents: [EKEvent]

    var id: Date { date }
    var isEmpty: Bool { holidays.isEmpty && normalEvents.isEmpty }
    var allEvents: [EKEvent] { holidays + normalEvents }

    static func == (lhs: EventDaySection, rhs: EventDaySection) -> Bool {
        lhs.date == rhs.date
            && lhs.holidays.map(\.eventIdentifier) == rhs.holidays.map(\.eventIdentifier)
            && lhs.normalEvents.map(\.eventIdentifier) == rhs.normalEvents.map(\.eventIdentifier)
    }
}

// MARK: - ViewModel

final class EventListScopeViewModel: ObservableObject {

    @Published var scope: EventListScope = .day {
        didSet {
            guard oldValue != scope else { return }
            reload()
        }
    }

    /// scope 안에서 날짜별로 grouped된 이벤트.
    /// day → 1개, week → 7개, month → 28~31개.
    @Published private(set) var sections: [EventDaySection] = []

    private(set) var anchorDate: Date = Date()
    private(set) var firstWeekday: Int = 1

    /// 평탄화된 visible events (필요시 사용).
    var visibleEvents: [EKEvent] {
        sections.flatMap { $0.allEvents }
    }

    // MARK: - 외부 갱신 API

    /// anchor 또는 첫 요일이 변경될 때 호출.
    func update(anchor: Date, firstWeekday: Int) {
        let normalizedAnchor = anchor.startOfDay
        let anchorChanged = normalizedAnchor != anchorDate
        let weekChanged = firstWeekday != self.firstWeekday

        self.anchorDate = normalizedAnchor
        self.firstWeekday = firstWeekday

        if anchorChanged || weekChanged || sections.isEmpty {
            reload()
        }
    }

    /// 날짜 이동 액션 전용: anchor를 갱신하고 scope를 day로 리셋.
    /// `update(...)` + 별도 `scope = .day` 호출 시 reload가 두 번 일어나는 것을 방지.
    /// 항상 하나의 reload만 실행되며, 그 시점에는 anchor·scope 모두 새 값.
    func snapToDay(anchor: Date, firstWeekday: Int) {
        let newAnchor = anchor.startOfDay
        let anchorChanged = newAnchor != self.anchorDate
        let firstWeekdayChanged = firstWeekday != self.firstWeekday
        let scopeChanged = scope != .day

        self.anchorDate = newAnchor
        self.firstWeekday = firstWeekday

        if scopeChanged {
            // didSet이 reload() 호출 — 이 시점에 anchorDate는 이미 새 값.
            self.scope = .day
        } else if anchorChanged || firstWeekdayChanged || sections.isEmpty {
            reload()
        }
    }

    /// 외부 이벤트(추가/삭제 등) 후 강제 갱신.
    func reload() {
        let dates = visibleDates()
        guard let first = dates.first, let last = dates.last else {
            sections = []
            return
        }

        let range = first.startOfDay...last.lastOfDay
        let holidays = EventManager.shared.fetchAllHolidays(in: range)
        let normals = EventManager.shared.fetchAllNormalEvents(in: range)

        sections = dates.map { day in
            EventDaySection(
                date: day,
                holidays: filter(events: holidays, on: day)
                    .sorted { ($0.title ?? "") < ($1.title ?? "") },
                normalEvents: filter(events: normals, on: day)
                    .sorted { $0.startDate < $1.startDate }
            )
        }
    }

    // MARK: - 헬퍼

    func isAnchorDay(_ date: Date) -> Bool {
        date.startOfDay == anchorDate.startOfDay
    }

    /// 현재 scope의 모든 날짜 (각 startOfDay).
    func visibleDates() -> [Date] {
        switch scope {
        case .day:
            return [anchorDate.startOfDay]
        case .week:
            return anchorDate.datesInWeek(firstWeekday: firstWeekday)
        case .month:
            return anchorDate.datesInMonth
        }
    }

    /// 특정 날짜에 걸치는 이벤트 (multi-day 이벤트 포함).
    /// EKEventStore가 recurring 이벤트는 expand해서 반환하므로 별도 처리 없이 동작.
    private func filter(events: [EKEvent], on day: Date) -> [EKEvent] {
        let dayStart = day.startOfDay
        return events.filter { event in
            let eventStart = event.startDate.startOfDay
            let eventEnd = event.endDate.startOfDay
            return dayStart >= eventStart && dayStart <= eventEnd
        }
    }
}

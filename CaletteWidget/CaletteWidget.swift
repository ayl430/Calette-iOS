//
//  CaletteWidget.swift
//  CaletteWidget
//
//  Created by yeri on 2/2/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> CalendarEntry {
        CalendarEntry(date: Date(), selectedDate: Date(), eventDays: [], dayEventInfos: [:])
    }

    func getSnapshot(in context: Context, completion: @escaping (CalendarEntry) -> ()) {
        let entry = buildEntry(for: Date(), selectedDate: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CalendarEntry>) -> ()) {
        let dateVM = DateViewModel()
        let currentDate = Date()

        var selectedDate = dateVM.selectedDate
        if dateVM.shouldReset(context: .widget) {
            dateVM.resetToToday()
            selectedDate = Date()
        }

        var entries: [CalendarEntry] = []
        entries.append(buildEntry(for: currentDate, selectedDate: selectedDate))
        let nextResetDate = dateVM.nextResetDate

        // 리셋 예약 or 즉시 업데이트
        if nextResetDate > currentDate {
            entries.append(buildEntry(for: nextResetDate, selectedDate: Date()))

            let timeline = Timeline(entries: entries, policy: .after(nextResetDate))
            completion(timeline)
        } else {
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }

    /// 이벤트 정보 사전 계산
    private func buildEntry(for date: Date, selectedDate: Date) -> CalendarEntry {
        let eventDays = EventManager.shared.fetchAllEventsThisMonth(date: selectedDate) ?? []
        let monthEventInfos = EventManager.shared.fetchMonthEventInfos(for: selectedDate)

        // 날짜별 이벤트 정보 변환
        var dayEventInfos: [String: DayEventInfo] = [:]
        for (dateKey, info) in monthEventInfos {
            let events = info.events
            dayEventInfos[dateKey] = DayEventInfo(
                date: Date(),
                eventCount: info.eventCount,
                isHoliday: info.isHoliday,
                firstEventTitle: events.first?.title,
                firstEventIsHoliday: events.first?.isHoliday ?? false,
                secondEventTitle: events.count > 1 ? events[1].title : nil,
                secondEventIsHoliday: events.count > 1 ? events[1].isHoliday : false
            )
        }

        return CalendarEntry(
            date: date,
            selectedDate: selectedDate,
            eventDays: eventDays,
            dayEventInfos: dayEventInfos
        )
    }
}

struct CalendarEntry: TimelineEntry {
    let date: Date
    let selectedDate: Date
    let eventDays: [Date]
    /// 날짜별 이벤트 정보 (key: "yyyy-MM-dd")
    let dayEventInfos: [String: DayEventInfo]
}

struct CaletteWidget: Widget {
    let kind: String = AppData.widgetName
    
    @StateObject private var calendarSettingVM = CalendarSettingsViewModel()
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CalendarView(entry: entry)
                .padding(2)
                .containerBackground(.white.dark(Color(hex: "1C1C1E")), for: .widget)
                .environmentObject(calendarSettingVM)
        }
        .supportedFamilies([.systemLarge])
        .configurationDisplayName(AppInfo.widgetName)
        .description(AppInfo.widgetDescription)
    }
}

#Preview(as: .systemLarge) {
    CaletteWidget()
} timeline: {
    CalendarEntry(date: .now, selectedDate: .now, eventDays: [], dayEventInfos: [:])
}

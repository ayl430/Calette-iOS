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
        CalendarEntry(date: Date(), selectedDate: Date(), eventDays: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (CalendarEntry) -> ()) {
        let eventDays = EventManager.shared.fetchAllEventsThisMonth(date: Date()) ?? []
        let entry = CalendarEntry(date: Date(), selectedDate: Date(), eventDays: eventDays)
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
        let eventDays = EventManager.shared.fetchAllEventsThisMonth(date: selectedDate) ?? []
        entries.append(CalendarEntry(date: currentDate, selectedDate: selectedDate, eventDays: eventDays))
        let nextResetDate = dateVM.nextResetDate

        // 리셋 예약 or 즉시 업데이트
        if nextResetDate > currentDate {
            let resetEventDays = EventManager.shared.fetchAllEventsThisMonth(date: Date()) ?? []
            entries.append(CalendarEntry(date: nextResetDate, selectedDate: Date(), eventDays: resetEventDays))
            
            let timeline = Timeline(entries: entries, policy: .after(nextResetDate))
            completion(timeline)
        } else {
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct CalendarEntry: TimelineEntry {
    let date: Date
    let selectedDate: Date
    let eventDays: [Date]
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
    CalendarEntry(date: .now, selectedDate: .now, eventDays: [])
    CalendarEntry(date: .now, selectedDate: .now, eventDays: [])
}

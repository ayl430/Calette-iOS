//
//  JustCalendarWidget.swift
//  JustCalendarWidget
//
//  Created by yeri on 2/2/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> CalendarEntry {
        CalendarEntry(date: Date(), selectedDate: DateModel.shared)
    }

    func getSnapshot(in context: Context, completion: @escaping (CalendarEntry) -> ()) {
        let entry = CalendarEntry(date: Date(), selectedDate: DateModel.shared)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CalendarEntry>) -> ()) {
        var entries: [CalendarEntry] = []

        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .second, value: hourOffset, to: currentDate)!
            let entry = CalendarEntry(date: entryDate, selectedDate: DateModel.shared)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct CalendarEntry: TimelineEntry {
    let date: Date
    let selectedDate: DateModel
}

struct JustCalendarWidget: Widget {
    let kind: String = "JustCalendarWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CalendarView(entry: entry, viewModel: WidgetSettingModel())
                .containerBackground(.fill.tertiary, for: .widget)
                .environmentObject(DateModel.shared)
        }
        .supportedFamilies([.systemLarge])
        .configurationDisplayName(AppInfo.appName)
        .description("This is an example widget.")
    }
}

#Preview(as: .systemLarge) {
    JustCalendarWidget()
} timeline: {
    CalendarEntry(date: .now, selectedDate: DateModel.shared)
    CalendarEntry(date: .now, selectedDate: DateModel.shared)
}

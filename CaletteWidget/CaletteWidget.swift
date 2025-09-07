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
        CalendarEntry(date: Date(), selectedDate: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (CalendarEntry) -> ()) {
        let entry = CalendarEntry(date: Date(), selectedDate: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<CalendarEntry>) -> ()) {
        var entries: [CalendarEntry] = []
        
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .second, value: hourOffset, to: currentDate)!
            let entry = CalendarEntry(date: entryDate, selectedDate: Date())
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct CalendarEntry: TimelineEntry {
    let date: Date
    let selectedDate: Date
}

struct CaletteWidget: Widget {
    let kind: String = AppData.widgetName
    
    @StateObject private var calendarSettingVM = CalendarSettingsViewModel()
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CalendarView(entry: entry)
                .padding(2)
                .containerBackground(.fill.tertiary, for: .widget)
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
    CalendarEntry(date: .now, selectedDate: .now)
    CalendarEntry(date: .now, selectedDate: .now)
}

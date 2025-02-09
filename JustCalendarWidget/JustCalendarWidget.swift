//
//  JustCalendarWidget.swift
//  JustCalendarWidget
//
//  Created by yeri on 2/2/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), selectedDate: DateModel.shared)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), selectedDate: DateModel.shared)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 1 {
            let entryDate = Calendar.current.date(byAdding: .second, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, selectedDate: DateModel.shared)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
//    let emoji: String
    
    let selectedDate: DateModel
}



//struct JustCalendarWidgetEntryView : View {
//    var entry: Provider.Entry
//
//    var body: some View {
//        VStack {
//            Text("Time:")
//            Text(entry.date, style: .time)
//
//            Text("Emoji:")
//            Text(entry.emoji)
//        }
//    }
//}

struct JustCalendarWidget: Widget {
    let kind: String = "JustCalendarWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            
//            JustCalendarWidgetEntryView(entry: entry)
            CalendarView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
                .environmentObject(DateModel.shared)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
//        .supportedFamilies([.systemLarge]) // 이건 왜 에러가 나는걸까
    }
}

#Preview(as: .systemLarge) {
    JustCalendarWidget()
} timeline: {
    SimpleEntry(date: .now, selectedDate: DateModel.shared)
    SimpleEntry(date: .now, selectedDate: DateModel.shared)
}

//
//  PreviousMonthWidget.swift
//  Calette
//
//  Created by yeri on 3/3/26.
//

import WidgetKit
import SwiftUI

struct PreviousMonthWidgetProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> PreviousMonthWidgetEntry {
        PreviousMonthWidgetEntry(date: Date(), previousMonth: Date().priorMonth, firstDayOfWeek: 1)
    }

    func snapshot(for configuration: PreviousMonthWidgetConfigurationIntent, in context: Context) async -> PreviousMonthWidgetEntry {
        PreviousMonthWidgetEntry(date: Date(), previousMonth: Date().priorMonth, firstDayOfWeek: configuration.firstDayOfWeek.rawValue)
    }

    func timeline(for configuration: PreviousMonthWidgetConfigurationIntent, in context: Context) async -> Timeline<PreviousMonthWidgetEntry> {
        let calendar = Calendar.current
        let now = Date()
        let previousMonth = now.priorMonth

        let entry = PreviousMonthWidgetEntry(
            date: now,
            previousMonth: previousMonth,
            firstDayOfWeek: configuration.firstDayOfWeek.rawValue
        )

        // 다음 달 1일 자정에 타임라인 갱신
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: now.startOfMonth) ?? now
        return Timeline(entries: [entry], policy: .after(nextMonth))
    }
}

struct PreviousMonthWidgetEntry: TimelineEntry {
    let date: Date
    let previousMonth: Date
    let firstDayOfWeek: Int
}

struct PreviousMonthWidget: Widget {
    let kind: String = "PreviousMonthWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: PreviousMonthWidgetConfigurationIntent.self, provider: PreviousMonthWidgetProvider()) { entry in
            PreviousMonthWidgetView(entry: entry)
                .containerBackground(.white.dark(Color(hex: "1C1C1E")), for: .widget)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("이전 달")
        .description("이전 달의 달력을 표시합니다")
    }
}

#Preview(as: .systemSmall) {
    PreviousMonthWidget()
} timeline: {
    PreviousMonthWidgetEntry(date: .now, previousMonth: Date().priorMonth, firstDayOfWeek: 1)
}

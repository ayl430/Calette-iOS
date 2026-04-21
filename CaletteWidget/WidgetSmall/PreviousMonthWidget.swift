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
        PreviousMonthWidgetEntry(date: Date(), displayMonth: Date().priorMonth, firstDayOfWeek: 1)
    }

    func snapshot(for configuration: PreviousMonthWidgetConfigurationIntent, in context: Context) async -> PreviousMonthWidgetEntry {
        let displayMonth = configuration.monthDisplay == .previousMonth
            ? Date().priorMonth
            : Date().nextMonth
        return PreviousMonthWidgetEntry(date: Date(), displayMonth: displayMonth, firstDayOfWeek: configuration.firstDayOfWeek.rawValue)
    }

    func timeline(for configuration: PreviousMonthWidgetConfigurationIntent, in context: Context) async -> Timeline<PreviousMonthWidgetEntry> {
        let calendar = Calendar.current
        let now = Date()

        let displayMonth = configuration.monthDisplay == .previousMonth
            ? now.priorMonth
            : now.nextMonth

        let entry = PreviousMonthWidgetEntry(
            date: now,
            displayMonth: displayMonth,
            firstDayOfWeek: configuration.firstDayOfWeek.rawValue
        )

        // 다음 달 1일 자정에 타임라인 갱신
        let nextUpdate = calendar.date(byAdding: .month, value: 1, to: now.startOfMonth) ?? now
        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }
}

struct PreviousMonthWidgetEntry: TimelineEntry {
    let date: Date
    let displayMonth: Date
    let firstDayOfWeek: Int
}

struct PreviousMonthWidget: Widget {
    let kind: String = "PreviousMonthWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: PreviousMonthWidgetConfigurationIntent.self, provider: PreviousMonthWidgetProvider()) { entry in
            PreviousMonthWidgetView(entry: entry)
                .containerBackground(
                    LinearGradient(
                        colors: [Color(hex: "231A3D"), Color(hex: "0D0D14")],
                        startPoint: .top, endPoint: .bottom
                    ),
                    for: .widget
                )
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("이전 / 다음 달")
        .description("이전 달 또는 다음 달의 달력을 표시합니다")
    }
}

#Preview(as: .systemSmall) {
    PreviousMonthWidget()
} timeline: {
    PreviousMonthWidgetEntry(date: .now, displayMonth: Date().priorMonth, firstDayOfWeek: 1)
}

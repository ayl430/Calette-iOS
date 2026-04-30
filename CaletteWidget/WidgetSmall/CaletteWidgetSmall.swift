//
//  CaletteWidgetSmall.swift
//  Calette
//
//  Created by yeri on 12/18/25.
//

import WidgetKit
import SwiftUI

struct CaletteWidgetSmallProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> CaletteWidgetSmallEntry {
        CaletteWidgetSmallEntry(date: Date(), backgroundColor: .dustyLavender, hasEvent: false, isHoliday: false)
    }

    func snapshot(for configuration: SmallWidgetConfigurationIntent, in context: Context) async -> CaletteWidgetSmallEntry {
        let hasEvent = EventManager.shared.hasNormalEvent(Date())
        let isHoliday = EventManager.shared.isHoliday(Date())
        return CaletteWidgetSmallEntry(date: Date(), backgroundColor: configuration.backgroundColor, hasEvent: hasEvent, isHoliday: isHoliday)
    }

    func timeline(for configuration: SmallWidgetConfigurationIntent, in context: Context) async -> Timeline<CaletteWidgetSmallEntry> {
        var entries: [CaletteWidgetSmallEntry] = []
        let calendar = Calendar.current
        let now = Date()

        // 오늘부터 7일간의 엔트리 생성 (자정 기준)
        for dayOffset in 0..<7 {
            guard let entryDate = calendar.date(byAdding: .day, value: dayOffset, to: calendar.startOfDay(for: now)) else { continue }

            let hasEvent = EventManager.shared.hasNormalEvent(entryDate)
            let isHoliday = EventManager.shared.isHoliday(entryDate)

            let entry = CaletteWidgetSmallEntry(
                date: entryDate,
                backgroundColor: configuration.backgroundColor,
                hasEvent: hasEvent,
                isHoliday: isHoliday
            )
            entries.append(entry)
        }

        // 7일 후 자정에 타임라인 갱신
        let nextUpdate = calendar.date(byAdding: .day, value: 7, to: calendar.startOfDay(for: now))!
        return Timeline(entries: entries, policy: .after(nextUpdate))
    }
}

struct CaletteWidgetSmallEntry: TimelineEntry {
    let date: Date
    let backgroundColor: WidgetBackgroundColor
    let hasEvent: Bool
    let isHoliday: Bool
}

struct CaletteWidgetSmall: Widget {
    let kind: String = "EmptySmallWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: SmallWidgetConfigurationIntent.self, provider: CaletteWidgetSmallProvider()) { entry in
            CaletteWidgetSmallView(entry: entry)
                .containerBackground(DesignSystem.Gradient.widgetCosmicBackground, for: .widget)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName(AppInfo.widgetName)
        .description(AppInfo.smallWidgetDescription)
    }
}

#Preview(as: .systemSmall) {
    CaletteWidgetSmall()
} timeline: {
    CaletteWidgetSmallEntry(date: .now, backgroundColor: .dustyLavender, hasEvent: true, isHoliday: false)
}

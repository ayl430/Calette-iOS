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
        CaletteWidgetSmallEntry(date: Date(), backgroundColor: .orange, hasEvent: false, isHoliday: false)
    }

    func snapshot(for configuration: SmallWidgetConfigurationIntent, in context: Context) async -> CaletteWidgetSmallEntry {
        let hasEvent = EventManager.shared.hasEvent(Date())
        let isHoliday = EventManager.shared.isHoliday(Date())
        return CaletteWidgetSmallEntry(date: Date(), backgroundColor: configuration.backgroundColor, hasEvent: hasEvent, isHoliday: isHoliday)
    }

    func timeline(for configuration: SmallWidgetConfigurationIntent, in context: Context) async -> Timeline<CaletteWidgetSmallEntry> {
        let hasEvent = EventManager.shared.hasEvent(Date())
        let isHoliday = EventManager.shared.isHoliday(Date())
        let entry = CaletteWidgetSmallEntry(date: Date(), backgroundColor: configuration.backgroundColor, hasEvent: hasEvent, isHoliday: isHoliday)
        return Timeline(entries: [entry], policy: .never)
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
                .containerBackground(entry.backgroundColor.color.dark(entry.backgroundColor.color), for: .widget)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName(AppInfo.widgetName)
        .description(AppInfo.smallWidgetDescription)
    }
}

#Preview(as: .systemSmall) {
    CaletteWidgetSmall()
} timeline: {
    CaletteWidgetSmallEntry(date: .now, backgroundColor: .orange, hasEvent: true, isHoliday: false)
}

//
//  WidgetCalendarDateView.swift
//  Calette
//
//  Created by yeri on 9/7/25.
//

import SwiftUI

struct WidgetCalendarDateView: View {

    var dateDate: Date //GMT
    var index: Int
    var selectedDate: Date
    var eventDays: [Date]

    var dayEventInfo: DayEventInfo?
    var designStyle: LargeWidgetDesignStyle = .cosmic

    @EnvironmentObject var calendarSettingVM: CalendarSettingsViewModel

    private var isSelected: Bool {
        selectedDate.startOfDay == dateDate.startOfDay
    }

    private var isSunday: Bool {
        calendarSettingVM.firstDayOfWeek == 1 ? index % 7 == 0 : index % 7 == 6
    }

    private var hasEvent: Bool {
        (dayEventInfo?.eventCount ?? 0) > 0
    }

    private var dateTextColor: Color {
        if designStyle == .cosmic {
            if isSelected { return DesignSystem.Colors.background }
            if isSunday   { return (WidgetTheme(rawValue: calendarSettingVM.themeColor) ?? .dustyLavender).color }
            return DesignSystem.Colors.primary
        } else {
            return isSunday
                ? Color(name: calendarSettingVM.themeColor)
                : DesignSystem.Colors.Widget.Classic.date
        }
    }

    var body: some View {
        ZStack {
            if isSelected {
                if designStyle == .cosmic {
                    Circle()
                        .fill((WidgetTheme(rawValue: calendarSettingVM.themeColor) ?? .dustyLavender).buttonGradient)
                        .overlay {
                            Circle()
                                .fill(DesignSystem.Gradient.buttonHighlight)
                                .allowsHitTesting(false)
                        }
                        .overlay {
                            Circle()
                                .strokeBorder(DesignSystem.Gradient.buttonBorder, lineWidth: 0.8)
                                .allowsHitTesting(false)
                        }
                        .shadow(color: DesignSystem.Shadow.card, radius: 3, x: 0, y: 2)
                        .shadow(color: (WidgetTheme(rawValue: calendarSettingVM.themeColor) ?? .dustyLavender).glowColor, radius: 6, x: 0, y: 1)
                } else {
                    Circle()
                        .fill(DesignSystem.Colors.Widget.Classic.selectedBG)
                }
            }

            VStack(spacing: 1) {
                Text("\(dateDate.get(component: .day))")
                    .font(.system(size: 14, weight: isSelected ? .bold : .semibold))
                    .foregroundStyle(dateTextColor)
                EventMarkingView(dateDate: dateDate, eventDays: eventDays, dayEventInfo: dayEventInfo, plusColor: designStyle == .cosmic ? DesignSystem.Colors.primary : DesignSystem.Colors.Widget.Classic.date, accentColor: (WidgetTheme(rawValue: calendarSettingVM.themeColor) ?? .dustyLavender).color)
                    .padding(.bottom, 2)
                Text("\(dateDate.lunarDate.toStringMdd())")
                    .font(.system(size: 8))
                    .foregroundStyle(
                        calendarSettingVM.isLunarCalendar && isSelected
                        ? (designStyle == .cosmic
                           ? DesignSystem.Colors.background.opacity(0.7)
                           : DesignSystem.Colors.Widget.Classic.lunar)
                        : Color.clear
                    )
            }

            Button(intent: SelectDateIntent(selectedDate: dateDate)) {
                Rectangle()
            }
            .foregroundStyle(Color.clear)
            .buttonStyle(.plain)
        }
        .offset(y: 3)
    }
}

//
//  CalendarDateView.swift
//  Calette
//
//  Created by yeri on 2/2/25.
//

import SwiftUI
import WidgetKit

struct CalendarDateView: View {
    
    var dateDate: Date //GMT
    var index: Int
    
    @EnvironmentObject var dateVM: DateViewModel
    @EnvironmentObject var calendarSettingVM: CalendarSettingsViewModel
    
    private var isSelected: Bool {
        dateVM.selectedDate.startOfDay == dateDate.startOfDay
    }

    private var isSunday: Bool {
        calendarSettingVM.firstDayOfWeek == 1 ? index % 7 == 0 : index % 7 == 6
    }

    private var hasEvent: Bool {
        dateVM.eventDays.contains { $0.startOfDay == dateDate.startOfDay }
    }

    private var dateTextColor: Color {
        if isSelected { return DesignSystem.Colors.background }
        if isSunday   { return DesignSystem.Colors.accent }
        return DesignSystem.Colors.primary
    }

    var body: some View {
        ZStack {
            // 선택된 날짜
            if isSelected {
                Circle()
                    .fill(calendarSettingVM.currentTheme.buttonGradient)
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
                    .shadow(color: calendarSettingVM.currentTheme.glowColor, radius: 6, x: 0, y: 1)
            }

            VStack(spacing: 1) {
                Text("\(dateDate.get(component: .day))")
                    .font(.system(size: 14, weight: hasEvent ? .semibold : .light))
                    .foregroundStyle(dateTextColor)

                EventMarkingView(dateDate: dateDate, eventDays: dateVM.eventDays, plusColor: dateTextColor)
                    .padding(.bottom, 2)

                Text("\(dateDate.lunarDate.toStringMdd())")
                    .font(.system(size: 8))
                    .foregroundStyle(
                        calendarSettingVM.isLunarCalendar && isSelected
                        ? DesignSystem.Colors.background.opacity(0.7)
                        : Color.clear
                    )
            }

            Button {
                DispatchQueue.main.async {
                    dateVM.setSelectedDate(date: dateDate)
                    WidgetCenter.shared.reloadAllTimelines()
                }
            } label: {
                Rectangle()
            }
            .foregroundStyle(Color.clear)
        }
    }
}

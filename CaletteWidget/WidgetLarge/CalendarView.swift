//
//  CalendarView.swift
//  CaletteWidget
//
//  Created by yeri on 2/2/25.
//

import WidgetKit
import SwiftUI

struct CalendarView: View {
    var entry: Provider.Entry
    
    let CalendarColumns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 0, alignment: .center), count: 7)
    
    let gridColumns: Int = 7
    let gridRows: Int = 8
    
    var displayDate: Date {
        return entry.selectedDate
    }
    
    @EnvironmentObject var calendarSettingVM: CalendarSettingsViewModel
    
    var body: some View {
        GeometryReader { geometry in
            let cellWidth = geometry.size.width / CGFloat(gridColumns)
            let cellHeight = geometry.size.height / CGFloat(gridRows)
            
            VStack(spacing: 0) {
                ZStack {
                    Button(intent: EmptyIntent()) {
                        Rectangle()
                            .fill(.clear)
                    }
                    .buttonStyle(.plain)
                    
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Text(displayDate.toString().hyphenToDot())
                                .font(.system(size: 21))
                                .foregroundStyle(
                                    entry.designStyle == .cosmic
                                    ? DesignSystem.Colors.primary
                                    : DesignSystem.Colors.Widget.Classic.title
                                )
                                .bold()
                                .padding(.horizontal)
                                .contentTransition(.identity)
                                .frame(
                                    width: 4.0 * cellWidth,
                                    height: 1.0 * cellHeight
                                )

                            if calendarSettingVM.isLunarCalendar {
                                MoonPhaseView(lunarDay: Int(displayDate.lunarDate.toStringD())!, isClassic: entry.designStyle == .classic)
                                    .frame(
                                        width: 1.0 * cellHeight,
                                        height: 1.0 * cellHeight
                                    )
                            }

                            Spacer()

                            if entry.designStyle == .cosmic {
                                Button(intent: TodayIntent()) {
                                    ZStack {
                                        Circle()
                                            .fill((WidgetTheme(rawValue: calendarSettingVM.themeColor) ?? .dustyLavender).buttonGradient)
                                        Circle()
                                            .fill(DesignSystem.Gradient.buttonHighlight)
                                            .allowsHitTesting(false)
                                        Circle()
                                            .strokeBorder(DesignSystem.Gradient.buttonBorder, lineWidth: 0.8)
                                            .allowsHitTesting(false)
                                        Image(systemName: "arrow.clockwise")
                                            .font(.system(size: 11, weight: .bold))
                                            .foregroundStyle(.white)
                                    }
                                    .frame(width: cellWidth * 0.72, height: cellHeight * 0.72)
                                    .shadow(color: DesignSystem.Shadow.card, radius: 3, x: 0, y: 2)
                                    .shadow(color: (WidgetTheme(rawValue: calendarSettingVM.themeColor) ?? .dustyLavender).glowColor, radius: 6, x: 0, y: 1)
                                }
                                .buttonStyle(.plain)
                                .frame(
                                    width: 1.0 * cellWidth,
                                    height: 1.0 * cellHeight
                                )
                            } else {
                                Button(intent: TodayIntent()) {
                                    Image(systemName: "arrow.clockwise")
                                        .frame(width: cellWidth * 0.7, height: cellHeight * 0.7)
                                        .font(.footnote)
                                        .foregroundStyle(Color.white)
                                        .bold()
                                        .background((WidgetTheme(rawValue: calendarSettingVM.themeColor) ?? .dustyLavender).color)
                                }
                                .clipShape(Circle())
                                .buttonStyle(.plain)
                                .frame(
                                    width: 1.0 * cellWidth,
                                    height: 1.0 * cellHeight
                                )
                            }
                        }
                        .frame(
                            width: 7.0 * cellWidth,
                            height: 1.0 * cellHeight
                        )
                        
                        LazyVGrid(columns: CalendarColumns, spacing: 0) {
                            if let days = CalendarBuilder.generateMonth(for: displayDate) {
                                ForEach(0..<days.count, id: \.self) { index in
                                    let day = days[index]
                                    if day.isInCurrentMonth {
                                        let dateKey = day.date.toString()
                                        WidgetCalendarDateView(
                                            dateDate: day.date,
                                            index: index,
                                            selectedDate: displayDate,
                                            eventDays: entry.eventDays,
                                            dayEventInfo: entry.dayEventInfos[dateKey],
                                            designStyle: entry.designStyle
                                        )
                                        .frame(width: cellWidth, height: cellHeight)
                                    } else {
                                        Rectangle()
                                            .fill(Color.clear)
                                            .frame(width: cellWidth, height: cellHeight)
                                    }
                                }
                            }
                        }
                    }
                }
                
                WidgetEventTitleView(cellWidth: cellWidth, cellHeight: cellHeight, selectedDate: displayDate, dayEventInfos: entry.dayEventInfos, designStyle: entry.designStyle)
            }
        }
    }
}

#Preview(as: .systemLarge) {
    CaletteWidget()
} timeline: {
    CalendarEntry(date: .now, selectedDate: .now, eventDays: [], dayEventInfos: [:], designStyle: .cosmic)
}

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

    @EnvironmentObject var calendarSettingVM: CalendarSettingsViewModel

    var body: some View {
        ZStack {
            if selectedDate.startOfDay == dateDate.startOfDay {
                Circle()
                    .fill(Color.selectedDateBG.dark(Color(hex: "413C38")))
            }

            VStack(spacing: 1) {
                Text("\(dateDate.get(component: .day))")
                    .font(.system(size: 14))
                EventMarkingView(dateDate: dateDate, eventDays: eventDays, dayEventInfo: dayEventInfo)
                    .padding(.bottom, 2)
                Text("\(dateDate.lunarDate.toStringMdd())")
                    .font(.system(size: 8))
                    .foregroundStyle(
                        calendarSettingVM.isLunarCalendar
                        ? (selectedDate.startOfDay == dateDate.startOfDay ? Color.lunarDate.dark(Color(hex: "A89E94")) : Color.clear)
                        : Color.clear
                    )
            }
            .foregroundStyle(
                calendarSettingVM.firstDayOfWeek == 1
                ? (index % 7 == 0 ? Color(name: calendarSettingVM.themeColor) : Color(hex: "4A4A4A").dark(Color(hex: "D4D0CC")))
                : (index % 7 == 6 ? Color(name: calendarSettingVM.themeColor) : Color(hex: "4A4A4A").dark(Color(hex: "D4D0CC")))
            )
            
            Button(intent: SelectDateIntent(selectedDate: dateDate)) {
                Rectangle()
            }
            .foregroundStyle(Color.clear)
            .buttonStyle(.plain)
        }
        .offset(y: 3)
    }
}

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
    
    @ObservedObject var dateVM: DateViewModel
    @EnvironmentObject var calendarSettingVM: CalendarSettingsViewModel
    
    var body: some View {
        ZStack {
            if dateVM.selectedDate.startOfDay == dateDate.startOfDay {
                Circle()
                    .fill(Color.bgSelectedDate)
            }
            
            VStack(spacing: 1) {
                Text("\(dateDate.get(component: .day))")
                    .font(.system(size: 14))
                EventMarkingView(dateDate: dateDate).padding(.bottom, 2)
                Text("\(dateDate.lunarDate.toStringMdd())")
                    .font(.system(size: 8))
                    .foregroundStyle(
                        calendarSettingVM.isLunarCalendar
                        ? (dateVM.selectedDate.startOfDay == dateDate.startOfDay ? Color.lunarDate : Color.clear)
                        : Color.clear
                    )
            }
            .foregroundStyle(
                calendarSettingVM.firstDayOfWeek == 1
                ? (index % 7 == 0 ? Color(name: calendarSettingVM.themeColor) : Color.textBlack)
                : (index % 7 == 6 ? Color(name: calendarSettingVM.themeColor) : Color.textBlack)
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

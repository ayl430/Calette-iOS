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
    @ObservedObject var viewModel: CalendarSettingViewModel
    
    var body: some View {
        ZStack {
            if dateVM.selectedDate.startOfDay == dateDate.startOfDay {
                Circle()
                    .fill(Color.selectedDateBG)
            }
            
            VStack(spacing: 1) {
                Text("\(dateDate.get(component: .day))")
                    .font(.system(size: 14))
                EventMarkingView(dateDate: dateDate).padding(.bottom, 2)
                Text("\(dateDate.lunarDate.toStringMdd())")
                    .font(.system(size: 8))
                    .foregroundStyle(
                        viewModel.isLunarCalendar
                        ? (dateVM.selectedDate.startOfDay == dateDate.startOfDay ? Color.lunarDate : Color.clear)
                        : Color.clear
                    )
            }
            .foregroundStyle(
                viewModel.firstDayOfWeek == 1
                ? (index % 7 == 0 ? Color(name: viewModel.themeColor) : Color.black)
                : (index % 7 == 6 ? Color(name: viewModel.themeColor) : Color.black)
            )
            
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
        .offset(y: 3)
    }
}

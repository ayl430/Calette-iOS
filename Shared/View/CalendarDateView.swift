//
//  CalendarDateView.swift
//  Calette
//
//  Created by yeri on 2/2/25.
//

import SwiftUI
import Intents
import WidgetKit

struct CalendarDateView: View {
    
    var dateDate: Date //GMT
    var index: Int
    
    @ObservedObject private var dateModel = DateModel.shared
    @ObservedObject var viewModel: WidgetSettingModel
    
    var body: some View {
        ZStack {
            if dateModel.selectedDate.startOfDay == dateDate.startOfDay {
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
                        ? (dateModel.selectedDate.startOfDay == dateDate.startOfDay ? Color.lunarDate : Color.clear)
                        : Color.clear
                    )
            }
            .foregroundStyle(
                viewModel.firstDayOfWeek == 1
                ? (index % 7 == 0 ? Color(name: viewModel.themeColor) : Color.black)
                : (index % 7 == 6 ? Color(name: viewModel.themeColor) : Color.black)
            )
            
            Button {
                dateModel.setSelectedDate(date: dateDate)
                WidgetCenter.shared.reloadAllTimelines()
            } label: {
                Rectangle()
            }
            .foregroundStyle(Color.clear)
        }
        .offset(y: 3)
    }
}


struct WidgetCalendarDateView: View {
    
    var dateDate: Date //GMT
    var index: Int
    
    @ObservedObject private var dateModel = DateModel.shared
    @ObservedObject var viewModel: WidgetSettingModel
    
    var body: some View {
        ZStack {
            if dateModel.selectedDate.startOfDay == dateDate.startOfDay {
                Circle()
                    .fill(Color.bgSelectedDate)
            }
            //selectedDate의 달이 이달이 아니면 오늘에 circle
            
            VStack(spacing: 1) {
                Text("\(dateDate.get(component: .day))")
                    .font(.system(size: 14))
                EventMarkingView(dateDate: dateDate).padding(.bottom, 2)
                Text("\(dateDate.lunarDate.toStringMdd())")
                    .font(.system(size: 8))
                    .foregroundStyle(
                        viewModel.isLunarCalendar
                        ? (dateModel.selectedDate.startOfDay == dateDate.startOfDay ? Color.lunarDate : Color.clear)
                        : Color.clear
                    )
            }
            .foregroundStyle(
                viewModel.firstDayOfWeek == 1
                ? (index % 7 == 0 ? Color(name: viewModel.themeColor) : Color.textBlack)
                : (index % 7 == 6 ? Color(name: viewModel.themeColor) : Color.textBlack)
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

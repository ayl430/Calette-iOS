//
//  CalendarDateView.swift
//  JustCalendar
//
//  Created by yeri on 2/2/25.
//

import SwiftUI
import Intents
import WidgetKit

struct CalendarDateView: View {
    
    var dateDate: Date //GMT
    var date: Int //로컬 day
    var index: Int
    
    @ObservedObject private var dateModel = DateModel.shared
    @ObservedObject var viewModel: WidgetSettingModel
    
    var body: some View {
        ZStack {
            if dateModel.selectedDate.get(component: .day) == date {
                Circle()
                    .fill(Color.selectedDateBG)
            }
            if Date().toString() == dateDate.toString() {
                Circle()
                    .strokeBorder(Color(name: viewModel.themeColor, alpha: 0.3), lineWidth: 2)
                    .fill(.clear)
            }
            
            VStack(spacing: 1) {
                Text("\(date)")
                    .font(.system(size: 14))
                EventMarkingView(dateDate: dateDate).padding(.bottom, 2)
                Text("\(dateDate.lunarDate.toStringMdd())")
                    .font(.system(size: 8))
                    .foregroundStyle(
                        viewModel.isLunarCalendar
                        ? (dateModel.selectedDate.get(component: .day) == date ? Color.lunarDate : Color.clear)
                        : Color.clear
                    )
            }
            .foregroundStyle(
                viewModel.firstDayOfWeek == 1
                ? (index % 7 == 0 ? Color(name: viewModel.themeColor) : Color.black)
                : (index % 7 == 6 ? Color(name: viewModel.themeColor) : Color.black)
            )
            
            Button {
                let startOfMonth = dateModel.selectedDate.startOfMonth
                dateModel.selectedDate = Calendar.current.date(byAdding: DateComponents(day: date - 1), to: startOfMonth)!
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
    var date: Int //로컬 day
    var index: Int
    
    @ObservedObject private var dateModel = DateModel.shared
    @ObservedObject var viewModel: WidgetSettingModel
    
    var body: some View {
        ZStack {
            if dateModel.selectedDate.get(component: .day) == date {
                Circle()
                    .fill(Color.selectedDateBG)
            }
            if Date().toString() == dateDate.toString() {
                Circle()
                    .strokeBorder(Color(name: viewModel.themeColor, alpha: 0.3), lineWidth: 2)
                    .fill(.clear)
            }
            
            VStack(spacing: 1) {
                Text("\(date)")
                    .font(.system(size: 14))
                EventMarkingView(dateDate: dateDate).padding(.bottom, 2)
                Text("\(dateDate.lunarDate.toStringMdd())")
                    .font(.system(size: 8))
                    .foregroundStyle(
                        viewModel.isLunarCalendar
                        ? (dateModel.selectedDate.get(component: .day) == date ? Color.lunarDate : Color.clear)
                        : Color.clear
                    )
            }
            .foregroundStyle(
                viewModel.firstDayOfWeek == 1
                ? (index % 7 == 0 ? Color(name: viewModel.themeColor) : Color.black)
                : (index % 7 == 6 ? Color(name: viewModel.themeColor) : Color.black)
            )
            
            
            Button(intent: SelectDateIntent(dayValue: date)) {
                Rectangle()
            }
            .foregroundStyle(Color.clear)
            .buttonStyle(.plain)
        }
        .offset(y: 3)
    }
}

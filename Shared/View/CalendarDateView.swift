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
        Button(intent: SelectDateIntent(dayValue: date)) {
            VStack(spacing: 3) {
                ZStack {
                    Circle()
                        .fill(dateModel.selectedDate.get(component: .day) == date ? Color.selectedDateBG : Color.clear)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 25, height: 25)
                    if Date().toString() == dateDate.toString() {
                        Circle()
                            .strokeBorder(Color(name: viewModel.themeColor, alpha: 0.3), lineWidth: 2)
                            .fill(.clear)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 25, height: 25)
                    }
                    VStack(spacing: 1) {
                        Text("\(date)")
                            .font(.system(size: 13))
                        EventMarkingView(dateDate: dateDate)
                    }
                }
                Text("\(dateDate.lunarDate.toStringMdd())")
                    .font(.system(size: 8))
                    .foregroundStyle(
                        viewModel.isLunarCalendar
                        ? (dateModel.selectedDate.get(component: .day) == date ? Color.lunarDate : Color.clear)
                        : Color.clear
                    )
            }
        }
        .frame(width: 40, height: 30)
        .buttonStyle(.plain)
        .padding(.horizontal)
        .foregroundStyle(
            viewModel.firstDayOfWeek == 1
            ? (index % 7 == 0 ? Color(name: viewModel.themeColor) : Color.black)
            : (index % 7 == 6 ? Color(name: viewModel.themeColor) : Color.black)
        )
        .bold()
    }
}

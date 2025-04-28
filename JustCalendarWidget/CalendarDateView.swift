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
    
    var dateDate: Date
    var date: Int
    var index: Int
    
    @ObservedObject private var dateModel = DateModel.shared
    @ObservedObject var viewModel: WidgetSettingModel
    
    var body: some View {        
        Button(intent: SelectDateIntent(dayValue: date)) {
            VStack(spacing: 3) {
                ZStack {
                    VStack(spacing: 1) {
                        Text("\(date)")
                            .font(.system(size: 12))
                        EventMarkingView(dateDate: dateDate, date: date)
                    }
                    
                    Circle()
                        .fill(dateModel.selectedDate.get(component: .day) == date ? Color.black.opacity(0.1) : Color.clear)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 25, height: 25)
                }
                Text("\(dateDate.lunarDate.toStringMdd())")
                    .font(.system(size: 8))
                    .foregroundStyle(dateModel.selectedDate.get(component: .day) == date ? Color(hex: "7A7A7A") : Color.clear)
            }
        }
        .frame(width: 40, height: 30)
        .buttonStyle(.plain)
        .padding(.horizontal)
        .foregroundStyle(
            viewModel.firstDayOfWeek == 1
            ? (index % 7 == 0 ? Color.justDefaultColor : Color.black)
            : (index % 7 == 6 ? Color.justDefaultColor : Color.black)
        )
        .bold()
    }
}

struct EmptyCalendarDateView: View {
    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(width: 40, height: 30)
    }
}
#Preview(as: .systemLarge) {
    JustCalendarWidget()
} timeline: {
    SimpleEntry(date: .now, selectedDate: DateModel.shared)
    SimpleEntry(date: .now, selectedDate: DateModel.shared)
}

//
//  CalendarView.swift
//  JustCalendar
//
//  Created by yeri on 2/2/25.
//

import WidgetKit
import SwiftUI

struct CalendarView: View {
    var entry: Provider.Entry
    
    let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 0, alignment: .center), count: 7)
    
    @ObservedObject private var dateModel = DateModel.shared
    @ObservedObject var viewModel: WidgetSettingModel
    
    var body: some View {
        ZStack {
            Button(intent: EmptyIntent()) {
                Rectangle()
                    .fill(.clear)
            }
            .buttonStyle(.plain)
            
            VStack(spacing: 5) {
                HStack {
                    Text(dateModel.selectedDate.toString().hyphenToDot())
                        .font(.system(size: 21))
                        .bold()
                        .padding(.horizontal)
                        .contentTransition(.identity)
                    
                    Spacer()
                    
                    HStack {
                        Button(intent: TodayIntent()) {
                            Image(systemName: "square")
                                .frame(width: 30, height: 30)
                                .font(.caption)
                                .foregroundStyle(Color.white)
                                .bold()
                        }
                        .buttonStyle(.plain)
                        .background(WidgetTheme(rawValue: viewModel.themeColor)!.color)
                        .clipShape(Circle())
                    }
                }
                .padding(.bottom, 15)
                
                LazyVGrid(columns: columns) {
                    if let days = CalendarBuilder.generateMonth(for: dateModel.selectedDate) {
                        ForEach(0..<days.count, id: \.self) { index in
                            let day = days[index]
                            if  day.isInCurrentMonth {
                                CalendarDateView(dateDate: day.date, date: day.date.get(component: .day), index: index, viewModel: viewModel)
                                    .aspectRatio(contentMode: .fill)
                            } else {
                                EmptyCalendarDateView()
                            }
                        }
                    }
                }
                
                
                ZStack {
                    Rectangle()
                        .fill(Color.clear)
                        .overlay(alignment: .top) {
                            EventDetailView(cellWidth: 40.0, cellHeight: 40.0)
                        }
                }
            }
            .padding(.horizontal, 5)
            .padding(.vertical, 20)
        }
    }
}

#Preview(as: .systemLarge) {
    JustCalendarWidget()
} timeline: {
    CalendarEntry(date: .now, selectedDate: DateModel.shared)
    CalendarEntry(date: .now, selectedDate: DateModel.shared)
}

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
    
    var sevenDays = ["일", "월", "화", "수", "목", "금", "토"]
//    @State var thisMonthDays = DateModel.shared.selectedDate.getDays()
//    @State var thisMonthDaysDate = DateModel.shared.selectedDate.getDaysDate()
    let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 0, alignment: .center), count: 7)
    
    @ObservedObject private var dateModel = DateModel.shared
    
    @ObservedObject var viewModel: WidgetSettingModel
    
//    let sharedUserDefaults = WidgetSettingsManager.shared.themeColor
    @AppStorage(WidgetSettings.Keys.themeColorKey, store: UserDefaults.shared) var color: String = "justDefaultColor"
    @AppStorage(WidgetSettings.Keys.firstDayOfWeekKey, store: UserDefaults.shared) var sunOrMon: Int = 1
    
    private let capsuleButtonWidth: CGFloat = 60
    
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
                                .font(.caption)
                        }
                        .frame(width: 30, height: 30)
                        .background(
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .fill(WidgetTheme(rawValue: color)!.color)
                        )
                        .padding(.horizontal, 5)
                        .buttonStyle(.plain)
                        .foregroundStyle(Color.white)
                        .bold()
                        
                        HStack(spacing: 0) {
                            Button(intent: PriorMonthIntent()) {
                                RoundedRectangle(cornerRadius: capsuleButtonWidth / 4, style: .continuous)
                                    .fill(WidgetTheme(rawValue: color)!.color)
                                    .frame(width: capsuleButtonWidth, height: capsuleButtonWidth / 2)
                                    .offset(x: capsuleButtonWidth / 4)
                                    .clipped()
                                    .offset(x: -capsuleButtonWidth / 4)
                                    .frame(width: capsuleButtonWidth / 2)
                                    .overlay {
                                        Image(systemName: "lessthan")
                                            .font(.caption)
                                            .foregroundStyle(Color.white)
                                            .bold()
                                            .offset(x: -capsuleButtonWidth / 8)
                                    }
                            }
                            .frame(width: 30, height: 30)
                            .buttonStyle(.plain)
                            
                            Rectangle()
                                .fill(WidgetTheme(rawValue: color)!.color)
                                .frame(width: 1, height: capsuleButtonWidth / 2)
                                .overlay {
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(width: 1, height: capsuleButtonWidth / 4)
                                }
                            
                            Button(intent: NextMonthIntent()) {
                                RoundedRectangle(cornerRadius: capsuleButtonWidth / 4, style: .continuous)
                                    .fill(WidgetTheme(rawValue: color)!.color)
                                    .frame(width: capsuleButtonWidth, height: capsuleButtonWidth / 2)
                                    .offset(x: -capsuleButtonWidth / 4)
                                    .clipped()
                                    .offset(x: capsuleButtonWidth / 4)
                                    .frame(width: capsuleButtonWidth / 2)
                                    .overlay {
                                        Image(systemName: "greaterthan")
                                            .font(.caption)
                                            .foregroundStyle(Color.white)
                                            .bold()
                                            .offset(x: capsuleButtonWidth / 8)
                                    }
                            }
                            .frame(width: 30, height: 30)
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 15)
                
                LazyVGrid(columns: columns) {
                    if let days = CalendarBuilder.generateMonth(for: dateModel.selectedDate, firstWeekday: viewModel.firstDayOfWeek) {
                        ForEach(0..<days.count, id: \.self) { index in
                            let day = days[index]
                            if  day.isInCurrentMonth {
                                CalendarDateView(dateDate: day.date, date: day.date.getDay(), index: index, viewModel: viewModel)
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
                            EventDetailView()
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
    SimpleEntry(date: .now, selectedDate: DateModel.shared)
    SimpleEntry(date: .now, selectedDate: DateModel.shared)
}

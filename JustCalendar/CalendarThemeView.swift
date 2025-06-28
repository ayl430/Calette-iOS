//
//  CalendarThemeView.swift
//  JustCalendar
//
//  Created by yeri on 6/3/25.
//

import SwiftUI

struct CalendarThemeView: View {
    var sevenDays = ["일", "월", "화", "수", "목", "금", "토"]
    @State var thisMonthDays = DateModel.shared.selectedDate.getDays()
    @State var thisMonthDaysDate = DateModel.shared.selectedDate.getDaysDate()
    let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 0, alignment: .center), count: 7)
    
    @ObservedObject private var dateModel = DateModel.shared
    
    @ObservedObject var viewModel: WidgetSettingModel
    
//    let sharedUserDefaults = WidgetSettingsManager.shared.themeColor
    @AppStorage(WidgetSettings.Keys.themeColorKey, store: UserDefaults.shared) var color: String = "justDefaultColor"
    @AppStorage(WidgetSettings.Keys.firstDayOfWeekKey, store: UserDefaults.shared) var sunOrMon: Int = 1
    
    private let capsuleButtonWidth: CGFloat = 60
    
    var body: some View {
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
            
            // 날짜 사이에 간격이 없어야 날짜를 누를때 간격을 눌러서 앱으로 이동할 일이 없음
            LazyVGrid(columns: columns) {
                if viewModel.firstDayOfWeek == 2 {
                    let dayOfWeekFirst = dateModel.selectedDate.dayOfWeekFirst == 1 ? 8 : dateModel.selectedDate.dayOfWeekFirst
                    let emptyBeforeFirstDays = (dayOfWeekFirst - 2)
                    let emptyAndThisMonthDays = emptyBeforeFirstDays + thisMonthDays.count
                    ForEach(0..<emptyAndThisMonthDays, id: \.self) { index in
                        if index <= emptyBeforeFirstDays - 1 || index > emptyAndThisMonthDays {
                            EmptyCalendarDateView()
                        } else {
                            CalendarDateView(dateDate: thisMonthDaysDate[index - emptyBeforeFirstDays], date: thisMonthDays[index - emptyBeforeFirstDays], index: index, viewModel: viewModel)
                                .aspectRatio(contentMode: .fill)
                        }
                    }
                } else if viewModel.firstDayOfWeek == 1 {
                    let zeroToLastDay = (dateModel.selectedDate.dayOfWeekFirst - 1) + thisMonthDays.count
                    ForEach(0..<zeroToLastDay, id: \.self) { index in
                        if index + 1 < dateModel.selectedDate.dayOfWeekFirst || index >= zeroToLastDay {
                            EmptyCalendarDateView()
                        } else { //6-(7-1)
                            CalendarDateView(dateDate: thisMonthDaysDate[index - (dateModel.selectedDate.dayOfWeekFirst - 1)], date: thisMonthDays[index - (dateModel.selectedDate.dayOfWeekFirst - 1)], index: index, viewModel: viewModel)
                                .aspectRatio(contentMode: .fill)
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
        
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

//#Preview {
//    CalendarThemeView()
//}

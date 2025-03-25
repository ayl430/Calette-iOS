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
    @State var thisMonthDays = DateModel.shared.selectedDate.getDays()
    let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 10, alignment: .center), count: 7)
    
    @ObservedObject private var dateModel = DateModel.shared
    
//    let sharedUserDefaults = WidgetSettingsManager.shared.themeColor
    @AppStorage(WidgetSettings.Keys.themeColorKey, store: UserDefaults.shared) var color: String = "justDefaultColor"
    
    private let capsuleButtonWidth: CGFloat = 60
    
    var body: some View {
        VStack {
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
            
            // 날짜 사이에 간격이 없어야 날짜를 누를때 간격을 눌러서 앱으로 이동할 일이 없음
            LazyVGrid(columns: columns) {
                let countToDraw = (dateModel.selectedDate.dayOfWeekFirst - 1) + thisMonthDays.count
                ForEach((0..<42), id: \.self) { index in
                    if index + 1 < dateModel.selectedDate.dayOfWeekFirst || index >= countToDraw {
                        EmptyCalendarDateView()
                    } else {
                        CalendarDateView(date: thisMonthDays[index - (dateModel.selectedDate.dayOfWeekFirst - 1)], index: index)
                            .aspectRatio(contentMode: .fill)
                    }
                }
            }
            
            if let events = EventManager.shared.getEvents(date: dateModel.selectedDate) {
                EventDetailView()
            }
        }
        .padding(.horizontal, 5)
        
        
        }
}

#Preview(as: .systemLarge) {
    JustCalendarWidget()
} timeline: {
    SimpleEntry(date: .now, selectedDate: DateModel.shared)
    SimpleEntry(date: .now, selectedDate: DateModel.shared)
}

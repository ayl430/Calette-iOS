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
    @State var days = DateModel.shared.today.getDays()
    let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 10, alignment: .center), count: 7)
    
    @ObservedObject private var selectedDate = DateModel.shared //변수명 수정!!
    
    var body: some View {
        VStack {
            HStack {
                Button(intent: PriorMonthIntent()) {
                    Text("<")
                }
                .frame(width: 30, height: 30)
                .buttonStyle(.plain)
                .padding(.horizontal)
//                .border(.black, width: 1)
                .foregroundStyle(Color.black)
                .bold()
                
                Text(selectedDate.today.toString().hyphenToDot())
                    .font(.system(size: 12))
                    .padding(.horizontal)
                
                Button(intent: NextMonthIntent()) {
                    Text(">")
                }
                .frame(width: 30, height: 30)
                .buttonStyle(.plain)
                .padding(.horizontal)
//                .border(.black, width: 1)
                .foregroundStyle(Color.black)
                .bold()
            }
            
                // 요일
//                LazyVGrid(columns: columns) {
//                    ForEach(0..<7, id: \.self) { index in
//                        Text(sevenDays[index])
//                            .font(.system(size: 10))
//                        //                        .padding()
//                            .foregroundStyle(sevenDays[index] == "일" ? Color.yellow : Color.black)
//                    }
//                }
//
//                Divider()
            
            LazyVGrid(columns: columns) {
                let countToDraw = (selectedDate.today.dayOfWeekFirst - 1) + days.count
                ForEach((0..<42), id: \.self) { index in
                        if index + 1 < selectedDate.today.dayOfWeekFirst || index >= countToDraw {
//                            Text(" ")
                            EmptyCalendarDateView()
                        } else {
                            CalendarDateView(day: "\(days[index - (selectedDate.today.dayOfWeekFirst - 1)])",
                                             index: index)
                            .aspectRatio(contentMode: .fill)
                        }
                    }
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

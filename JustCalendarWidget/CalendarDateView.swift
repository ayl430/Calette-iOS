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
    
    var date: Int
    var index: Int
    
    @ObservedObject private var dateModel = DateModel.shared
    
    var body: some View {        
        Button(intent: SelectDateIntent(dayValue: date)) {
            ZStack {
                VStack(spacing: 3) {
                    Text("\(date)")
                        .font(.system(size: 12))
                    Circle()
                        .fill(dateModel.hasEvent(on: date) ? (dateModel.isHoliday(on: date) ? Color.red : Color.blue) : Color.clear)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 3, height: 3)
                }
                
                if dateModel.selectedDate.get(component: .day) == date {
                    Circle()
                        .fill(Color.clear)
                        .stroke(Color.black)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30)
                }
            }
        }
        .frame(width: 40, height: 25)
        .buttonStyle(.plain)
        .padding(.horizontal)
        .foregroundStyle(
            index % 7 == 0 ? Color.justDefaultColor : Color.black)
        .bold()
    }
}

struct EmptyCalendarDateView: View {
    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(width: 40, height: 25)
    }
}

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
    
    var day: String
    var index: Int
    
    @ObservedObject private var viewModel = DateModel.shared
    
    var body: some View {        
        Button(intent: SelectDateIntent(dayValue: Int(day)!)) {
            
            ZStack {
                VStack {
                    Text(day)
                        .font(.system(size: 10))
                    Circle()
                        .fill(viewModel.hasEvent(on: day) ? Color.blue : Color.clear)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 5, height: 5)
                }
                
                if viewModel.today.get(component: .day) == Int(day)! {
                    Circle()
                        .fill(Color.clear)
                        .stroke(Color.black)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30)
                }
            }
        }
        .frame(width: 30, height: 30)
        .buttonStyle(.plain)
        .padding(.horizontal)
        .foregroundStyle(
            index % 7 == 0 ? Color.yellow : Color.black)
        .bold()
    }
}

struct EmptyCalendarDateView: View {
    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(width: 30, height: 30)
    }
}

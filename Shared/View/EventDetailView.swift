//
//  EventDetailView.swift
//  JustCalendar
//
//  Created by yeri on 2/3/25.
//

import SwiftUI

struct EventDetailView: View {
    @ObservedObject private var dateModel = DateModel.shared
    
    var body: some View {
        let events = EventManager.shared.fetchAllEventItems(date: dateModel.selectedDate)
        
        if !events.isEmpty {
            VStack(spacing: 16) {
                let eventCount = events.count
                let count = events.count == 1 ? 1 : (dateModel.maxEventDetailViewLines() == 1 ? 1 : 2)
                ForEach(0..<count, id: \.self) { index in
                    HStack() {
                        Rectangle()
                            .fill(events[index].calendarTitle == "대한민국 공휴일" ? Color.red : Color.blue)
                            .frame(width: 2, height: 10)
                            .padding(.leading, 10)
                        
                        Text(events[index].title ?? "")
                            .font(.system(size: 12))
                            .foregroundStyle(Color(hex: "#686868"))
                            .padding(.leading, 10)
                        Spacer()
                        if eventCount > 2 && index == 1 {
                            ZStack {
                                Rectangle()
                                    .frame(width: 5, height: 1, alignment: .center)
                                Rectangle()
                                    .frame(width: 1, height: 5, alignment: .center)
                            }
                            .padding(.trailing, 10)
                        }
                    }
                }
            }
            
        } else {
            HStack {
                EventEmptyView()
                Spacer()
            }
        }
        
    }
}

#Preview {
    EventDetailView()
}

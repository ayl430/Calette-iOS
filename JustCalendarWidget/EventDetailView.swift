//
//  EventDetailView.swift
//  JustCalendar
//
//  Created by yeri on 2/3/25.
//

import SwiftUI

struct EventDetailView: View {
    
//    var selectedDate: Date
    @ObservedObject private var dateModel = DateModel.shared
    
    var body: some View {
        if let events = EventManager.shared.getEvents(date: dateModel.selectedDate) {
            if !events.isEmpty {
                VStack(spacing: 0) {
                    let eventCount = events.count
                    let count = eventCount > 2 ? 2 : eventCount
                    ForEach(0..<count, id: \.self) { index in
                        HStack() {
                            Rectangle()
                                .fill(dateModel.hasEvent(on: dateModel.selectedDate.local.getDay()) ? (dateModel.isHoliday(on: dateModel.selectedDate.local.getDay()) ? Color.red : Color.blue) : Color.clear)
                                .frame(width: 1, height: 10)
                                .padding(.leading, 5)
                            
                            Text(events[index].title ?? "")
                                .font(.system(size: 12))
                                .foregroundStyle(Color(hex: "#686868"))
                                .padding()
                            Spacer()
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
}

struct EventEmptyView: View {
    var body: some View {
        Image(systemName: "tree")
            .frame(width: 45, height: 45)
            .foregroundStyle(Color.gray)
    }
}


#Preview {
//    EventDetailView(selectedDate: Date())
    EventDetailView()
}

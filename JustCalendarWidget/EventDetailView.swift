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
    
        HStack() {
            Rectangle()
                .fill(dateModel.hasEvent(on: dateModel.selectedDate.local.getDay()) ? (dateModel.isHoliday(on: dateModel.selectedDate.local.getDay()) ? Color.red : Color.blue) : Color.clear)
                .frame(width: 1, height: 10)
                .padding(.leading, 5)
            
            if let events = EventManager.shared.getEvents(date: dateModel.selectedDate) {
                if !events.isEmpty {
                    Text(events[0].title ?? "")
                        .font(.system(size: 12))
                        .padding()
                }
            }
            
            Spacer()
        }
//        .background(Color.gray.opacity(0.3))
        .frame(width: 300, height: 30, alignment: .leading)
    }
}

#Preview {
//    EventDetailView(selectedDate: Date())
    EventDetailView()
}

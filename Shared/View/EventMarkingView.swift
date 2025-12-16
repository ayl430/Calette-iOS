//
//  EventMarkingView.swift
//  Calette
//
//  Created by yeri on 4/16/25.
//

import SwiftUI

struct EventMarkingView: View {
    var dateDate: Date
    var eventDays: [Date]
    
    // 위젯에서만 사용
    var dayEventInfo: DayEventInfo?

    private var hasEvent: Bool {
        if let info = dayEventInfo {
            return info.eventCount > 0
        }
        return eventDays.contains { $0.startOfDay == dateDate.startOfDay } // 앱
    }

    private var isHoliday: Bool {
        if let info = dayEventInfo {
            return info.isHoliday
        }
        return EventManager.shared.isHoliday(dateDate)
    }

    private var eventCount: Int {
        if let info = dayEventInfo {
            return info.eventCount
        }
        return EventManager.shared.fetchAllEvents(date: dateDate).count
    }

    var body: some View {
        if hasEvent {
            EventMarkingSubView(isHoliday: isHoliday, moreThanTwo: eventCount >= 2)
        } else {
            Circle()
                .fill(Color.clear)
                .aspectRatio(contentMode: .fill)
                .frame(width: 3, height: 3)
        }
    }
}

struct EventMarkingSubView: View {
    let isHoliday: Bool
    let moreThanTwo: Bool
    
    var body: some View {
        HStack(spacing: 2) {
            Circle()
                .fill(isHoliday ? Color.red : Color.blue)
                .aspectRatio(contentMode: .fill)
                .frame(width: 3, height: 3)
            if moreThanTwo {
                ZStack {
                    Rectangle()
                        .frame(width: 3, height: 1, alignment: .center)
                    Rectangle()
                        .frame(width: 1, height: 3, alignment: .center)
                }
            }
        }
    }
}

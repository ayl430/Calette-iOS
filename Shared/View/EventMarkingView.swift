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

    // + 기호 색상 (날짜 숫자 색과 동일하게 전달, 기본값: primary)
    var plusColor: Color = DesignSystem.Colors.primary
    // 이벤트 도트 accent 색 (테마색 반영)
    var accentColor: Color = DesignSystem.Colors.accent

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
            EventMarkingSubView(isHoliday: isHoliday, moreThanTwo: eventCount >= 2, plusColor: plusColor, accentColor: accentColor)
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
    var plusColor: Color = DesignSystem.Colors.primary
    var accentColor: Color = DesignSystem.Colors.accent

    var body: some View {
        HStack(spacing: 2) {
            Circle()
                .fill(isHoliday ? DesignSystem.Colors.holiday : accentColor)
                .aspectRatio(contentMode: .fill)
                .frame(width: 3, height: 3)
            if moreThanTwo {
                ZStack {
                    Rectangle()
                        .fill(plusColor)
                        .frame(width: 3, height: 1, alignment: .center)
                    Rectangle()
                        .fill(plusColor)
                        .frame(width: 1, height: 3, alignment: .center)
                }
            }
        }
    }
}

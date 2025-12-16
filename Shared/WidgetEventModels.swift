//
//  WidgetEventModels.swift
//  Calette
//
//  Created by Claude on 12/15/25.
//

import Foundation

/// 날짜별 이벤트 정보 (위젯)
struct DayEventInfo: Hashable {
    let date: Date
    let eventCount: Int
    let isHoliday: Bool
    let firstEventTitle: String?
    let firstEventIsHoliday: Bool
    let secondEventTitle: String?
    let secondEventIsHoliday: Bool
}

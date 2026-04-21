//
//  PreviousMonthWidgetConfigurationIntent.swift
//  Calette
//
//  Created by yeri on 3/3/26.
//

import WidgetKit
import AppIntents

// 시작 요일 선택
enum FirstDayOfWeek: Int, AppEnum {
    case sunday = 1
    case monday = 2

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "시작 요일"
    }

    static var caseDisplayRepresentations: [FirstDayOfWeek: DisplayRepresentation] {
        [
            .sunday: DisplayRepresentation(title: "일요일"),
            .monday: DisplayRepresentation(title: "월요일")
        ]
    }
}

// 표시할 달 선택
enum MonthDisplay: String, AppEnum {
    case previousMonth
    case nextMonth

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "표시할 달"
    }

    static var caseDisplayRepresentations: [MonthDisplay: DisplayRepresentation] {
        [
            .previousMonth: DisplayRepresentation(title: "이전 달"),
            .nextMonth:     DisplayRepresentation(title: "다음 달")
        ]
    }
}

struct PreviousMonthWidgetConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "위젯 설정"
    static var description = IntentDescription("이전/다음 달 위젯을 설정합니다.")

    @Parameter(title: "표시할 달", default: .previousMonth)
    var monthDisplay: MonthDisplay

    @Parameter(title: "시작 요일", default: .sunday)
    var firstDayOfWeek: FirstDayOfWeek
}

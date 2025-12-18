//
//  SmallWidgetConfigurationIntent.swift
//  Calette
//
//  Created by yeri on 12/18/25.
//

import WidgetKit
import AppIntents

struct SmallWidgetConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "위젯 설정"
    static var description = IntentDescription("위젯의 배경 색상을 설정합니다.")

    @Parameter(title: "배경 색상", default: .orange)
    var backgroundColor: WidgetBackgroundColor
}

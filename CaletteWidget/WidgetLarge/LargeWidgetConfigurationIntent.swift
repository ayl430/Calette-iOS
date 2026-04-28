//
//  LargeWidgetConfigurationIntent.swift
//  Calette
//
//  Created by yeri on 4/28/26.
//

import WidgetKit
import AppIntents

struct LargeWidgetConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "위젯 설정"
    static var description = IntentDescription("위젯의 디자인 스타일을 설정합니다.")

    @Parameter(title: "디자인 스타일", default: .cosmic)
    var designStyle: LargeWidgetDesignStyle
}

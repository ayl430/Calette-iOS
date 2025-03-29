//
//  WidgetSettingModel.swift
//  JustCalendar
//
//  Created by yeri on 2/22/25.
//

import Foundation
import SwiftUI

class WidgetSettingModel: ObservableObject {
    @Published var isOnTheme: Bool = WidgetSettingsManager.shared.isOnTheme
    @Published var themeColor: String = WidgetSettingsManager.shared.themeColor
    @Published var firstDayOfWeek: Int = WidgetSettingsManager.shared.firstDayOfWeek // 일요일 1, 월요일 2
    @Published var isLunarCalendar: Bool = WidgetSettingsManager.shared.isLunarCalendar
    
    func setTheme(color: String) {
        WidgetSettingsManager.shared.themeColor = color
        themeColor = color
    }
    
    func setFirstDayOfWeek(day: Int) {
        WidgetSettingsManager.shared.firstDayOfWeek = day
        firstDayOfWeek = day
    }
}

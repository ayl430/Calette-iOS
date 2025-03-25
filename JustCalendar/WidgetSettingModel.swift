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
    @Published var firstDayOfWeek: String = WidgetSettingsManager.shared.firstDayOfWeek
    @Published var isLunarCalendar: Bool = WidgetSettingsManager.shared.isLunarCalendar
    
    func setTheme(color: String) {
        WidgetSettingsManager.shared.themeColor = color
        themeColor = color
    }
    
    func get(color: String) -> Color {
        if let theme = WidgetTheme(rawValue: themeColor) {
            return theme.color
        }
        return WidgetTheme.justDefaultColor.color
    }
}

//
//  WidgetSettingModel.swift
//  JustCalendar
//
//  Created by yeri on 7/10/25.
//

import Foundation
import SwiftUI
import WidgetKit

class WidgetSettingModel: ObservableObject  {
    
    @AppStorage(WidgetSettings.Keys.themeColorKey, store: UserDefaults.shared) var color: String = "justDefaultColor"
    @AppStorage(WidgetSettings.Keys.firstDayOfWeekKey, store: UserDefaults.shared) var sunOrMon: Int = 1
    @AppStorage(WidgetSettings.Keys.isLunarCalendarKey, store: UserDefaults.shared) var lunarCalendar: Bool = false
    
    var isOnTheme: Bool {
        get {
            return !(themeColor.isEmpty || themeColor == WidgetTheme.justDefaultColor.name)
        }
    }
    
    var themeColor: String {
        get {
            return color
        }
        set {
            color = newValue
            reloadWidget(named: WidgetSettings.widgetName)
        }
    }
    
    var firstDayOfWeek: Int {
        get {
            return sunOrMon
        }
        set {
            sunOrMon = newValue
            reloadWidget(named: WidgetSettings.widgetName)
        }
    }
    
    var isLunarCalendar: Bool {
        get {
            return lunarCalendar
        }
        set {
            lunarCalendar = newValue
            reloadWidget(named: WidgetSettings.widgetName)
        }
    }
    
    
    
    private func reloadWidget(named widgetName: String) {
        WidgetCenter.shared.getCurrentConfigurations { result in
            guard case .success(let widgets) = result else { return }
            if let widget = widgets.first(where: { $0.kind == widgetName }) {
                WidgetCenter.shared.reloadTimelines(ofKind: widget.kind)
            }
        }
    }
    
    private func reloadAllTimelines() {
        WidgetCenter.shared.reloadAllTimelines()
    }
}

//
//  WidgetSettingsManager.swift
//  JustCalendar
//
//  Created by yeri on 2/22/25.
//

import Foundation
import SwiftUI
import WidgetKit

enum WidgetSettings {
    static let widgetName = "AddWidgetTestWidget"
    struct Keys {
        static let themeColorKey = "KEY_themeColor"
        static let firstDayOfWeekKey = "KEY_firstDayOfWeek"
        static let isLunarCalendarKey = "KEY_isLunarCalendar"
    }
}

class WidgetSettingsManager: NSObject {
    static let shared = WidgetSettingsManager()
    
    @AppStorage(WidgetSettings.Keys.themeColorKey, store: UserDefaults.shared) var color: String = "justDefaultColor"
    @AppStorage(WidgetSettings.Keys.firstDayOfWeekKey, store: UserDefaults.shared) var sunOrMon: Int = 1
    
    
    override private init() {
        super.init()
    }
    
    var isOnTheme: Bool {
        get {
            return !(themeColor.isEmpty || themeColor == WidgetTheme.justDefaultColor.name)
        }
    }
    
    var themeColor: String {
        get {
//            print("themeColor: \(UserDefaults.shared.getPreference(of: WidgetSettings.Keys.themeColorKey))")
//            return UserDefaults.shared.getPreference(of: WidgetSettings.Keys.themeColorKey)
            return color
        }
        set {
//            UserDefaults.shared.setPreference(of: WidgetSettings.Keys.themeColorKey, value: newValue)
//            reloadWidget(named: WidgetSettings.widgetName)
            color = newValue
            reloadWidget(named: WidgetSettings.widgetName)
        }
    }
    
    var firstDayOfWeek: Int {
        get {
//            return UserDefaults.shared.getPreference(of: WidgetSettings.Keys.firstDayOfWeekKey) ?? 1
            return sunOrMon
        }
        set {
//            UserDefaults.shared.setPreference(of: WidgetSettings.Keys.firstDayOfWeekKey, value: newValue)
            sunOrMon = newValue
            reloadWidget(named: WidgetSettings.widgetName)
        }
    }
    
    var isLunarCalendar: Bool {
        get {
            return UserDefaults.shared.getPreference(of: WidgetSettings.Keys.isLunarCalendarKey)
        }
        set {
            UserDefaults.shared.setPreference(of: WidgetSettings.Keys.isLunarCalendarKey, value: newValue)
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

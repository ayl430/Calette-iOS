//
//  CalendarSettingsViewModel.swift
//  Calette
//
//  Created by yeri on 7/10/25.
//

import Foundation
import SwiftUI
import WidgetKit

class CalendarSettingsViewModel: ObservableObject  {
    
    @AppStorage(DefaultsKeys.Shared.themeColorKey, store: UserDefaults.shared) var color: String = "caletteDefault"
    @AppStorage(DefaultsKeys.Shared.firstDayOfWeekKey, store: UserDefaults.shared) var sunOrMon: Int = 1
    @AppStorage(DefaultsKeys.Shared.isLunarCalendarKey, store: UserDefaults.shared) var lunarCalendar: Bool = false
    
    var isOnTheme: Bool {
        get {
            return !(themeColor.isEmpty || themeColor == WidgetTheme.caletteDefault.name)
        }
    }
    
    var themeColor: String {
        get {
            return color
        }
        set {
            color = newValue
            reloadWidget(named: AppData.widgetName)
        }
    }
    
    var firstDayOfWeek: Int {
        get {
            return sunOrMon
        }
        set {
            sunOrMon = newValue
            reloadWidget(named: AppData.widgetName)
        }
    }
    
    var isLunarCalendar: Bool {
        get {
            return lunarCalendar
        }
        set {
            lunarCalendar = newValue
            reloadWidget(named: AppData.widgetName)
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

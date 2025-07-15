//
//  AppInfo.swift
//  JustCalendar
//
//  Created by yeri on 5/7/25.
//

import Foundation

struct AppInfo {
    static var version: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
    }

    static var build: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
    }

    static var appName: String {
        return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
    }
}

enum AppSettings {
    static let appName = AppInfo.appName
    
    // 위젯 갤러리에서
    static let widgetName = AppInfo.appName
    static let widgetDescription = "캘린더와 일정을 빠르게 확인할 수 있어요"
    
    struct Keys {
        static let onboardingKey = "Key_onboarding"
    }
}


enum WidgetSettings {
    static let widgetName = "JustCalendarWidget"
    
    struct Keys {
        static let themeColorKey = "KEY_themeColor"
        static let firstDayOfWeekKey = "KEY_firstDayOfWeek"
        static let isLunarCalendarKey = "KEY_isLunarCalendar"
    }
}

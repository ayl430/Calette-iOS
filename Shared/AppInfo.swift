//
//  AppInfo.swift
//  Calette
//
//  Created by yeri on 5/7/25.
//

import Foundation

struct AppData {
    static var version: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
    }
    
    static var build: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
    }
    
    /// Calette
    static var appName: String {
        return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
    }
    
    /// Widget의 kind
    static let widgetName = "CaletteWidget"
        
    static let bundleId: String = "com.Yeali.Calette"
    static let appGroupId: String = "group.com.Yeali.Calette.shared"
}


enum AppInfo {
    static let appName = AppData.appName
    
    // 위젯 갤러리에서
    static let widgetName = AppData.appName
    static let widgetDescription = "캘린더와 일정을 빠르게 확인할 수 있어요"
}


struct DefaultsKeys {
    /// 앱
    struct App {
        static let onboardingKey = "Key_onboarding"
    }

    /// 앱 + 위젯 (App Group)
    struct Shared {
        static let selectedDateKey = "KEY_selectedDate"
        
        static let themeColorKey = "KEY_themeColor"
        static let firstDayOfWeekKey = "KEY_firstDayOfWeek"
        static let isLunarCalendarKey = "KEY_isLunarCalendar"
    }
}

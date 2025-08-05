//
//  UserDefaultsExtension.swift
//  JustCalendar
//
//  Created by yeri on 2/12/25.
//

import Foundation
import SwiftUI
import WidgetKit

public enum AppGroup {
    static let bundleId: String = "com.Yeali.JustCalendar"
    static let groupId: String = "group.com.Yeali.JustCalendar"
}

extension UserDefaults {
    
    /// user defaults shared with widget
    static var shared: UserDefaults {
        // 앱의 standard userdefaults를 쓸 때
        let appGroupID = AppGroup.groupId
        return UserDefaults(suiteName: appGroupID)!
        
        // 앱과 위젯의 standard userdefaults는 서로 다름
//        let combined = UserDefaults.standard
//        let appGroupId = "group.com.Yeali.JustCalendar"
//        combined.addSuite(named: appGroupId)
//        return combined
    }
    
    func getPreference(of key: String) -> String {
        if let value = UserDefaults.shared.value(forKey: key) as? String {
            return value
        } else {
            return ""
        }
    }
    
    func getPreference(of key: String) -> Bool {
        if let value = UserDefaults.shared.value(forKey: key) as? Bool {
            return value
        } else {
            return false
        }
    }
    
    func getPreference(of key: String) -> Int? {
        if let value = UserDefaults.shared.value(forKey: key) as? Int {
            return value
        } else {
            return nil
        }
    }
    
    func setPreference(of key: String, value: String) -> Void {
        UserDefaults.shared.set(value, forKey: key)
    }
    
    func setPreference(of key: String, value: Bool) -> Void {
        UserDefaults.shared.set(value, forKey: key)
    }
    
    func setPreference(of key: String, value: Int) -> Void {
        UserDefaults.shared.set(value, forKey: key)
    }
}

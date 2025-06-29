//
//  MainView.swift
//  JustCalendar
//
//  Created by yeri on 1/30/25.
//

import SwiftUI

// MARK: - 시작 MainView
// MainView -> (OnboardingTabView) -> ContentView
enum AppSettings {
    static let appName = "AddWidgetTestWidget"
    struct Keys {
        static let onboardingKey = "Key_onboarding"
    }
}

struct MainView: View {
    @AppStorage("onboarding") var isOnboarding: Bool = true
    
    var body: some View {
        ContentView()
            .fullScreenCover(isPresented: $isOnboarding) {
                OnboardingTabView(isOnboarding: $isOnboarding)
            }
    }
}

// MARK: - PreferenceKey
struct AppIconViewPreferenceKey: PreferenceKey {
    typealias Value = [Int: Anchor<CGRect>]
    
    static var defaultValue: [Int: Anchor<CGRect>] = [:]
    
    static func reduce(value: inout [Int: Anchor<CGRect>], nextValue: () -> [Int: Anchor<CGRect>]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}


#Preview(body: {
    MainView()
})

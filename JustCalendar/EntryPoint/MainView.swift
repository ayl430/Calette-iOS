//
//  MainView.swift
//  JustCalendar
//
//  Created by yeri on 1/30/25.
//

import SwiftUI

// MARK: - 시작 MainView
// MainView -> (OnboardingTabView) -> ContentView
struct MainView: View {
    @AppStorage(AppSettings.Keys.onboardingKey) var isOnboarding: Bool = true
    
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

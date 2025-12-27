//
//  MainView.swift
//  Calette
//
//  Created by yeri on 1/30/25.
//

import SwiftUI

// MARK: - 시작 MainView
// MainView -> (OnboardingView) -> ContentView
struct MainView: View {
    @AppStorage(DefaultsKeys.App.onboardingKey) var isOnboarding: Bool = true

    @EnvironmentObject var coordinator: Coordinator

    @StateObject private var calendarSettingVM = CalendarSettingsViewModel()

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ZStack {
                ContentView()
                    .navigationDestination(for: NavigationStackType.self) { stackViewType in
                        switch stackViewType {
                        case .HomeView:
                            MainView()
                        case .EventListView:
                            EventListView()
                        }
                    }
                    .environmentObject(calendarSettingVM)
                
                if isOnboarding {
                    OnboardingView(isOnboarding: $isOnboarding) {
                        NotificationCenter.default.post(name: .showSwipeHint, object: nil)
                    }
                }
            }
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

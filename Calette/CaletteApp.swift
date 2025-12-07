//
//  CaletteApp.swift
//  Calette
//
//  Created by yeri on 1/28/25.
//

import SwiftUI
import WidgetKit

@main
struct CaletteApp: App {
    
    @StateObject var coordinator: Coordinator = Coordinator()
    @StateObject var dateVM: DateViewModel = DateViewModel()
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear() {
                    if EventManager.shared.isFullAccess {
                        
                    } else {
                        Task {
                            try? await EventManager.shared.requestFullAccess()
                        }
                    }
                }
                .onOpenURL { url in
                    guard url.scheme == "widget-deeplink" else { return }
                    let components = URLComponents(string: "\(url)")
                    let query = components?.queryItems?.first(where: { $0.name == "url" })?.value
                    UIApplication.shared.open(URL(string: query ?? "calshow://")!)
                }
                .environmentObject(coordinator)
                .environmentObject(dateVM)
        }
        .onChange(of: scenePhase) { oldScenePhase, newScenePhase in
            switch newScenePhase {
            case .active:
                print("ScenePhase: Active.")
                dateVM.checkAndResetIfNeeded()
                WidgetCenter.shared.reloadAllTimelines()
            case .inactive:
                print("ScenePhase: Inactive.")
            case .background:
                print("ScenePhase: Background.")
            @unknown default:
                print("ScenePhase: Unknown.")
            }
        }
        
    }
}

//
//  JustCalendarApp.swift
//  JustCalendar
//
//  Created by yeri on 1/28/25.
//

import SwiftUI

@main
struct JustCalendarApp: App {
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
        }
    }
}

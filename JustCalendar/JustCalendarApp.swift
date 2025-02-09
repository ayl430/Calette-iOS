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
        }
    }
}

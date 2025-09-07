//
//  TodayIntent.swift
//  Calette
//
//  Created by yeri on 2/22/25.
//

import AppIntents
import WidgetKit

struct TodayIntent: AppIntent {
    static var title: LocalizedStringResource = "오늘"
    static var description = IntentDescription("오늘")
    
    @MainActor
    func perform() async throws -> some IntentResult {
        DateViewModel().setThisMonth()
//        WidgetCenter.shared.reloadAllTimelines()
        
        return .result()
    }
}

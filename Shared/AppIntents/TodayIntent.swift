//
//  TodayIntent.swift
//  Calette
//
//  Created by yeri on 2/22/25.
//

import AppIntents

struct TodayIntent: AppIntent {
    static var title: LocalizedStringResource = "오늘"
    static var description = IntentDescription("오늘")
    
    func perform() async throws -> some IntentResult {
        DateModel.shared.setThisMonth()
        
        return .result()
    }
}

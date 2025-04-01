//
//  TodayIntent.swift
//  JustCalendar
//
//  Created by yeri on 2/22/25.
//

import AppIntents

struct TodayIntent: AppIntent {
    static var title: LocalizedStringResource = "Go Today"
    static var description = IntentDescription("Go Today")
    
    func perform() async throws -> some IntentResult {
        DateModel.shared.setThisMonth()
        
        return .result()
    }
}

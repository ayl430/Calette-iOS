//
//  TodayIntent.swift
//  JustCalendar
//
//  Created by yeri on 2/22/25.
//

import AppIntents

struct TodayIntent: AppIntent { // 다른 달에서 오늘버튼 누르고 넘어오면 이벤트가 이상하게 뜸
    static var title: LocalizedStringResource = "Go Today"
    static var description = IntentDescription("Go Today")
    
    func perform() async throws -> some IntentResult {
        DateModel.shared.setThisMonth()
        
        return .result()
    }
}

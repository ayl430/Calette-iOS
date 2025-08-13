//
//  PriorMonthIntent.swift
//  JustCalendar
//
//  Created by yeri on 2/22/25.
//

import AppIntents

struct PriorMonthIntent: AppIntent {
    static var title: LocalizedStringResource = "이전 달"
    static var description = IntentDescription("이전 달")
    
//    init() {}
    
    func perform() async throws -> some IntentResult {
        DateModel.shared.setPriorMonth()
        
        return .result()
    }    
}

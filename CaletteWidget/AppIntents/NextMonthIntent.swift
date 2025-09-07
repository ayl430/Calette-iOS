//
//  NextMonthIntent.swift
//  Calette
//
//  Created by yeri on 2/22/25.
//

import AppIntents

struct NextMonthIntent: AppIntent {
    static var title: LocalizedStringResource = "다음 달"
    static var description = IntentDescription("다음 달")
    
//    init() {}
    
    func perform() async throws -> some IntentResult {
        DateViewModel().setNextMonth()
        
        return .result()
    }
}

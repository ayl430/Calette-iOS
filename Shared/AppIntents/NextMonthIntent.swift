//
//  NextMonthIntent.swift
//  JustCalendar
//
//  Created by yeri on 2/22/25.
//

import AppIntents

struct NextMonthIntent: AppIntent {
    static var title: LocalizedStringResource = "Next Month"
    static var description = IntentDescription("Next Month")
    
//    init() {}
    
    func perform() async throws -> some IntentResult {
        DateModel.shared.setNextMonth()
        
        return .result()
    }
}


struct EmptyIntent: AppIntent {
    static var title: LocalizedStringResource = "Empty Space"
    static var description = IntentDescription("Empty Space")
    
//    init() {}
    
    func perform() async throws -> some IntentResult {       
        
        return .result()
    }
}

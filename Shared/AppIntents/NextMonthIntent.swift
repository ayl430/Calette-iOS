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
        DateModel.shared.setNextMonth()
        
        return .result()
    }
}


struct EmptyIntent: AppIntent {
    static var title: LocalizedStringResource = "빈 탭"
    static var description = IntentDescription("빈 탭")
    
//    init() {}
    
    func perform() async throws -> some IntentResult {       
        
        return .result()
    }
}

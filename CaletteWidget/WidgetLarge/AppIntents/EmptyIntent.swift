//
//  EmptyIntent.swift
//  Calette
//
//  Created by yeri on 9/7/25.
//

import AppIntents

struct EmptyIntent: AppIntent {
    static var title: LocalizedStringResource = "빈 탭"
    static var description = IntentDescription("빈 탭")
    
//    init() {}
    
    func perform() async throws -> some IntentResult {
        
        return .result()
    }
}

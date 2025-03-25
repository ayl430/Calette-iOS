//
//  PriorMonthIntent.swift
//  JustCalendar
//
//  Created by yeri on 2/22/25.
//

import AppIntents

struct PriorMonthIntent: AppIntent {
    static var title: LocalizedStringResource = "Prior Month" //이건 안 바꿔도 되나
    static var description = IntentDescription("Prior Month")
    
//    init() {}
    
    func perform() async throws -> some IntentResult {
        DateModel.shared.setPriorMonth()
        
        return .result()
    }    
}

//
//  SelectDateIntent.swift
//  JustCalendar
//
//  Created by yeri on 2/2/25.
//

import AppIntents

struct PriorMonthIntent: AppIntent {
    static var title: LocalizedStringResource = "Prior Month"
    static var description = IntentDescription("Prior Month")
    
//    init() {}
    
    func perform() async throws -> some IntentResult {
        DateModel.shared.setPriorMonth()
        
        return .result()
    }
    
}


struct NextMonthIntent: AppIntent {
    static var title: LocalizedStringResource = "Next Month"
    static var description = IntentDescription("Next Month")
    
//    init() {}
    
    func perform() async throws -> some IntentResult {
        DateModel.shared.setNextMonth()
        
        return .result()
    }
    
}

struct SelectDateIntent: AppIntent {
    static var title: LocalizedStringResource = "Select Date"
    static var description = IntentDescription("Select Date")
    
    @Parameter(title:"DayValue")
    var dayValue: Int
    
    init() {}
    
    init(dayValue: Int) {
        self.dayValue = dayValue
    }
    
    func perform() async throws -> some IntentResult {
        let startOfMonth = DateModel.shared.today.startOfMonth
        DateModel.shared.today = Calendar.current.date(byAdding: DateComponents(day: dayValue - 1), to: startOfMonth)!
        
        print(DateModel.shared.today)
        return .result()
    }
    
}

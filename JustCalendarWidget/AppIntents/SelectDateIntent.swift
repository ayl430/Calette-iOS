//
//  SelectDateIntent.swift
//  JustCalendar
//
//  Created by yeri on 2/2/25.
//

import AppIntents

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
        let startOfMonth = DateModel.shared.selectedDate.startOfMonth.local
        DateModel.shared.selectedDate = Calendar.current.date(byAdding: DateComponents(day: dayValue - 1), to: startOfMonth)!
        
        return .result()
    }
}

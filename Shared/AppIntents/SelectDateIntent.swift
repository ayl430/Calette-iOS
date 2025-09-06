//
//  SelectDateIntent.swift
//  Calette
//
//  Created by yeri on 2/2/25.
//

import AppIntents
import WidgetKit

struct SelectDateIntent: AppIntent {
    static var title: LocalizedStringResource = "날짜 선택"
    static var description = IntentDescription("날짜 선택")
    
    @Parameter(title: "Selected Date")
    var selectedDate: Date
    
    init() {}
    
    init(selectedDate: Date) {
        self.selectedDate = selectedDate
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        DateViewModel().setSelectedDate(date: selectedDate)
//        WidgetCenter.shared.reloadAllTimelines() // 필요한지 체크
        
        return .result()
    }
}

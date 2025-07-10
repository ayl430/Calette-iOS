//
//  ArrayExtension .swift
//  JustCalendar
//
//  Created by yeri on 7/10/25.
//

import Foundation
import EventKit

extension Array {
    // 캘린더 이벤트를 오름차순으로 배열
    func sortedEventByAscendingDate() -> [EKEvent] {
        guard let self = self as? [EKEvent] else { return [] }
        
        return self.sorted(by: { (first: EKEvent, second: EKEvent) in
            return first.compareStartDate(with: second) == .orderedAscending
        })
    }
}

//
//  MonthGridView.swift
//  Calette
//
//  Created by yeri on 12/22/25.
//

import SwiftUI

struct MonthGridView: View {

    let targetDate: Date
    let cellWidth: CGFloat
    let cellHeight: CGFloat
    let fixedRows: Int  // 현재 달의 줄 수

    let CalendarColumns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 0, alignment: .center), count: 7)

    @EnvironmentObject var dateVM: DateViewModel

    var body: some View {
        VStack(spacing: 0) {
            LazyVGrid(columns: CalendarColumns, spacing: 0) {
                if let days = CalendarBuilder.generateMonth(for: targetDate) {
                    ForEach(0..<days.count, id: \.self) { index in
                        let day = days[index]
                        if day.isInCurrentMonth {
                            CalendarDateView(dateDate: day.date, index: index)
                                .frame(width: cellWidth, height: cellHeight)
                        } else {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(width: cellWidth, height: cellHeight)
                        }
                    }
                }
            }
            Spacer(minLength: 0)
        }
        .frame(height: CGFloat(fixedRows) * cellHeight)
    }
}

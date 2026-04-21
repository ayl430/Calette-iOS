//
//  PreviousMonthWidgetView.swift
//  Calette
//
//  Created by yeri on 3/3/26.
//

import SwiftUI
import WidgetKit

struct PreviousMonthWidgetView: View {
    var entry: PreviousMonthWidgetProvider.Entry

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)

    private var firstDayOfWeek: Int {
        entry.firstDayOfWeek
    }

    var body: some View {
        GeometryReader { geometry in
            let rowCount = calculateRowCount()

            // 주수에 따른 상하 여백 (6주: 최소, 5주/4주: 점점 증가)
            let verticalPadding: CGFloat = rowCount == 6 ? 4 : (rowCount == 5 ? 10 : 16)
            let horizontalPadding: CGFloat = 4
            let headerHeight: CGFloat = 20
            let rowSpacing: CGFloat = 8  // 주 간격은 동일

            let availableHeight = geometry.size.height - (verticalPadding * 2) - headerHeight
            let totalSpacing = rowSpacing * CGFloat(rowCount - 1)
            let cellHeight = (availableHeight - totalSpacing) / CGFloat(rowCount)
            let cellWidth = (geometry.size.width - horizontalPadding * 2) / 7

            VStack(spacing: 4) {
                // 월 헤더
                HStack {
                    Text("\(entry.previousMonth.get(component: .month))월")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color(hex: "4A4A4A").dark(Color(hex: "E5E5E5")))
                    Spacer()
                }
                .frame(height: headerHeight)
                .padding(.horizontal, 4)

                // 날짜 그리드
                if let days = CalendarBuilder.generateMonth(for: entry.previousMonth, firstWeekday: firstDayOfWeek) {
                    LazyVGrid(columns: columns, spacing: rowSpacing) {
                        ForEach(0..<days.count, id: \.self) { index in
                            let day = days[index]
                            if day.isInCurrentMonth {
                                dateCell(day: day, index: index, cellWidth: cellWidth, cellHeight: cellHeight)
                            } else {
                                Color.clear
                                    .frame(width: cellWidth, height: cellHeight)
                            }
                        }
                    }
                }
            }
//            .padding(.vertical, verticalPadding)
//            .padding(.horizontal, horizontalPadding)
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }

    @ViewBuilder
    private func dateCell(day: CalendarDay, index: Int, cellWidth: CGFloat, cellHeight: CGFloat) -> some View {
        let dayNumber = day.date.get(component: .day)

        ZStack {
            Text("\(dayNumber)")
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(dateColor(for: index))
        }
        .frame(width: cellWidth, height: cellHeight)
    }

    private func dateColor(for index: Int) -> Color {
        let actualIndex = firstDayOfWeek == 1 ? index % 7 : (index % 7 + 1) % 7

        if actualIndex == 0 { // 일요일
            return Color(hex: "FF6370")
        } else if actualIndex == 6 { // 토요일
            return Color(hex: "AEAEB2").dark(Color(hex: "8E8E93"))
        } else {
            return Color(hex: "4A4A4A").dark(Color(hex: "E5E5E5"))
        }
    }

    private func calculateRowCount() -> Int {
        guard let days = CalendarBuilder.generateMonth(for: entry.previousMonth, firstWeekday: firstDayOfWeek) else { return 5 }
        return days.count / 7
    }
}

#Preview {
    PreviousMonthWidgetView(entry: PreviousMonthWidgetEntry(date: Date(), previousMonth: Date().priorMonth, firstDayOfWeek: 1))
}

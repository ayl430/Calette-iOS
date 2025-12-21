//
//  WidgetEventTitleView.swift
//  Calette
//
//  Created by yeri on 9/7/25.
//

import SwiftUI

struct WidgetEventTitleView: View {

    var cellWidth: CGFloat
    var cellHeight: CGFloat
    var selectedDate: Date
    
    // 날짜별 이벤트 정보
    var dayEventInfos: [String: DayEventInfo]
    // 선택된 날짜의 이벤트 정보
    private var currentDateEventInfo: DayEventInfo? {
        let dateKey = selectedDate.toString()
        return dayEventInfos[dateKey]
    }

    var body: some View {
        VStack(spacing: 0) {
            let eventCount = currentDateEventInfo?.eventCount ?? 0
            let maxEventLines = CalendarBuilder.maxEventTitleViewLines(date: selectedDate)

            if eventCount == 0 {
                noEventView(lines: maxEventLines)
            } else {
                let eventLines = eventCount == 1 ? 1 : (maxEventLines == 1 ? 1 : 2)
                let emptyLines = maxEventLines - eventLines

                if let info = currentDateEventInfo {
                    // 첫 번째 이벤트
                    if let firstTitle = info.firstEventTitle {
                        eventRow(title: firstTitle, isHoliday: info.firstEventIsHoliday, showPlus: false)
                    }

                    // 두 번째 이벤트
                    if eventLines >= 2, let secondTitle = info.secondEventTitle {
                        eventRow(title: secondTitle, isHoliday: info.secondEventIsHoliday, showPlus: eventCount > 2)
                    }
                }

                if emptyLines != 0 {
                    clearView(lines: emptyLines)
                }
            }
        }
    }

    @ViewBuilder
    private func eventRow(title: String, isHoliday: Bool, showPlus: Bool) -> some View {
        HStack() {
            Rectangle()
                .fill(isHoliday ? Color(hex: "FF7A6B") : Color(hex: "6A8FE8"))
                .frame(width: 2, height: cellHeight * 0.3)
                .padding(.leading, 10)

            Text(title)
                .font(.system(size: 13))
                .foregroundStyle(Color(hex: "545354").dark(Color(hex: "C8C2BC")))
                .padding(.leading, 10)
            Spacer()
            if showPlus {
                ZStack {
                    Rectangle()
                        .frame(width: 5, height: 1, alignment: .center)
                    Rectangle()
                        .frame(width: 1, height: 5, alignment: .center)
                }
                .padding(.trailing, 10)
            }
        }
        .frame(
            width: 7.0 * cellWidth,
            height: 1.0 * cellHeight
        )
    }
    
    fileprivate func clearView(lines: Int) -> some View {
        let clearView = Rectangle()
            .fill(.clear)
            .frame(
                width: 7.0 * cellWidth,
                height: 1.0 * cellHeight
            )
        
        let view = ForEach(0..<lines, id: \.self) { index in
            clearView
        }
        
        return view
    }
    
    fileprivate func noEventImageView() -> some View {
        let imageView = ZStack {
            Rectangle()
                .fill(.clear)
                .frame(
                    width: 7.0 * cellWidth,
                    height: 1.0 * cellHeight
                )
            
            HStack {
                Image(systemName: "tree")
                    .frame(width: 0.5 * cellWidth, height: 0.5 * cellHeight)
                    .foregroundStyle(Color.gray)
                    .padding(.leading, 15)
                Spacer()
            }
        }
        
        return imageView
    }
    
    fileprivate func noEventView(lines: Int) -> some View {
        let view = VStack {
            noEventImageView()
            if lines > 1 {
                clearView(lines: lines - 1)
            }
        }
        
        return view
    }
}

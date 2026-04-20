//
//  EventTitleView.swift
//  Calette
//
//  Created by yeri on 7/30/25.
//

import SwiftUI

struct EventTitleView: View {
    
    var cellWidth: CGFloat
    var cellHeight: CGFloat
    
    @EnvironmentObject var dateVM: DateViewModel
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        let holidays = EventManager.shared.fetchAllHolidays(on: dateVM.selectedDate)
        let normalEvents = EventManager.shared.fetchAllNormalEvents(on: dateVM.selectedDate)
        let events = holidays + normalEvents
        
        VStack(spacing: 0) {
            let eventCount = events.count
            let maxEventLines = CalendarBuilder.maxEventTitleViewLines(date: dateVM.selectedDate)
            
            if eventCount == 0 {
                noEventView(lines: maxEventLines)
            } else {
                let hasOverEvent = eventCount > maxEventLines
                let visibleEventCount = hasOverEvent ? maxEventLines : eventCount
                let clearLineCount = maxEventLines - visibleEventCount
                
                ForEach(0..<visibleEventCount, id: \.self) { index in
                    ZStack {
                        HStack() {
                            Rectangle()
                                .fill(events[index].calendar.title == "대한민국 공휴일" ? DesignSystem.Colors.EventBar.holiday : DesignSystem.Colors.EventBar.normal)
                                .frame(width: 2, height: cellHeight * 0.3)
                                .padding(.leading, 10)

                            Text(events[index].title ?? "")
                                .font(.system(size: 13))
                                .foregroundStyle(DesignSystem.Colors.secondary)
                                .padding(.leading, 10)
                            Spacer()
                            if hasOverEvent && index == maxEventLines - 1 {
                                ZStack {
                                    Rectangle()
                                        .fill(DesignSystem.Colors.secondary)
                                        .frame(width: 8, height: 2, alignment: .center)
                                    Rectangle()
                                        .fill(DesignSystem.Colors.secondary)
                                        .frame(width: 2, height: 8, alignment: .center)
                                }
                                .padding(.trailing, 10)
                            }
                        }
                        
                        Button {
                            coordinator.push(.EventListView)
                        } label: {
                            Rectangle()
                        }
                        .foregroundStyle(Color.clear)
                    }
                    .frame(
                        width: 7.0 * cellWidth,
                        height: 1.0 * cellHeight
                    )
                }
                
                if clearLineCount > 0 {
                    clearView(lines: clearLineCount)
                }
            }
        }
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
                Image(systemName: "sparkles")
                    .frame(width: 0.5 * cellWidth, height: 0.5 * cellHeight)
                    .foregroundStyle(DesignSystem.Colors.primary)
                    .padding(.leading, 15)
                Spacer()
            }
            
            Button {
                coordinator.push(.EventListView)
            } label: {
                Rectangle()
            }
            .foregroundStyle(Color.clear)
//            .buttonStyle(.plain) // 앱에서는 안 눌리고, 위젯에서는 파란 바탕색이 뜸
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

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
    
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        let events = EventManager.shared.fetchAllEvents(date: selectedDate)
        
        VStack(spacing: 0) {
            let eventCount = events.count
            let maxEventLines = CalendarBuilder.maxEventTitleViewLines(date: selectedDate)
            
            if eventCount == 0 {
                noEventView(lines: maxEventLines)
            } else {
                let eventLines = eventCount == 1 ? 1 : (maxEventLines == 1 ? 1 : 2)
                let emptyLines = maxEventLines - eventLines
                ForEach(0..<eventLines, id: \.self) { index in
                    HStack() {
                        Rectangle()
                            .fill(events[index].calendar.title == "대한민국 공휴일" ? Color.red : Color.blue)
                            .frame(width: 2, height: cellHeight * 0.3)
                            .padding(.leading, 10)
                        
                        Text(events[index].title ?? "")
                            .font(.system(size: 13))
                            .foregroundStyle(Color(hex: "686868"))
                            .padding(.leading, 10)
                        Spacer()
                        if eventCount > 2 && index == 1 {
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
                
                if emptyLines != 0 {
                    clearView(lines: emptyLines)
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

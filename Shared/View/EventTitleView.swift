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
        let events = EventManager.shared.fetchAllEvents(date: dateVM.selectedDate)
        
        VStack(spacing: 0) {
            let eventCount = events.count
            let maxEventLines = dateVM.maxEventTitleViewLines()
            
            if eventCount == 0 {
                noEventView(lines: maxEventLines)
            } else {
                let eventLines = eventCount == 1 ? 1 : (maxEventLines == 1 ? 1 : 2)
                let emptyLines = maxEventLines - eventLines
                ForEach(0..<eventLines, id: \.self) { index in
                    ZStack {
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
                        
                        Button {
                            coordinator.push(.EventDetailView)
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
            
            Button {
                coordinator.push(.EventDetailView)
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


struct WidgetEventTitleView: View {
    
    var cellWidth: CGFloat
    var cellHeight: CGFloat
    
    @ObservedObject var dateVM: DateViewModel
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        let events = EventManager.shared.fetchAllEvents(date: dateVM.selectedDate)
        
        VStack(spacing: 0) {
            let eventCount = events.count
            let maxEventLines = dateVM.maxEventTitleViewLines()
            
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

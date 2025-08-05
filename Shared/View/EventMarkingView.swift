//
//  EventMarkingView.swift
//  JustCalendarWidgetExtension
//
//  Created by yeri on 4/16/25.
//

import SwiftUI

struct EventMarkingView: View {
    
    var dateDate: Date
    
    @ObservedObject private var dateModel = DateModel.shared
    
    var body: some View {
        if dateModel.hasEvent(on: dateDate) {
            if dateModel.isHoliday(on: dateDate) {
                if EventManager.shared.fetchAllEvents(date: dateDate).count >= 2 {
                    EventMarkingSubView(isHoliday: true, moreThanTwo: true)
                } else {
                    EventMarkingSubView(isHoliday: true, moreThanTwo: false)
                }
            } else {
                if EventManager.shared.fetchAllEvents(date: dateDate).count >= 2 {
                    EventMarkingSubView(isHoliday: false, moreThanTwo: true)
                } else {
                    EventMarkingSubView(isHoliday: false, moreThanTwo: false)
                }
            }
        } else {
            Circle()
                .fill(Color.clear)
                .aspectRatio(contentMode: .fill)
                .frame(width: 3, height: 3)
        }
    }
}

struct EventMarkingSubView: View {
    let isHoliday: Bool
    let moreThanTwo: Bool
    
    var body: some View {
        HStack(spacing: 2) {
            Circle()
                .fill(isHoliday ? Color.red : Color.blue)
                .aspectRatio(contentMode: .fill)
                .frame(width: 3, height: 3)
            if moreThanTwo {
                ZStack {
                    Rectangle()
                        .frame(width: 3, height: 1, alignment: .center)
                    Rectangle()
                        .frame(width: 1, height: 3, alignment: .center)
                }
            }
        }
    }
}

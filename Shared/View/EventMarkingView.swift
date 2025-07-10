//
//  EventMarkingView.swift
//  JustCalendarWidgetExtension
//
//  Created by yeri on 4/16/25.
//

import SwiftUI

struct EventMarkingView: View {
    
    var dateDate: Date
    var date: Int
    
    @ObservedObject private var dateModel = DateModel.shared
    
    var body: some View {
        if dateModel.hasEvent(on: dateDate) {
            if dateModel.isHoliday(on: dateDate) {
                    if EventManager.shared.fetchEvents(on: dateDate).count >= 2 {
                        HStack(spacing: 2) {
                            Circle()
                                .fill(Color.red)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 3, height: 3)
                            ZStack {
                                Rectangle()
                                    .frame(width: 3, height: 1, alignment: .center)
                                Rectangle()
                                    .frame(width: 1, height: 3, alignment: .center)
                            }
                        }
                    } else {
                        Circle()
                            .fill(Color.red)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 3, height: 3)
                    }
                } else {
                    if EventManager.shared.fetchEvents(on: dateDate).count >= 2 {
                        HStack(spacing: 2) {
                            Circle()
                                .fill(Color.blue)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 3, height: 3)
                            ZStack {
                                Rectangle()
                                    .frame(width: 3, height: 1, alignment: .center)
                                Rectangle()
                                    .frame(width: 1, height: 3, alignment: .center)
                            }
                        }
                    } else {
                        Circle()
                            .fill(Color.blue)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 3, height: 3)
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

#Preview {
//    EventMarkingView(date: 1, dateDate: Date())
}

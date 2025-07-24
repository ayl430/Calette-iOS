//
//  CalendarThemeView.swift
//  JustCalendar
//
//  Created by yeri on 6/3/25.
//

import SwiftUI

struct CalendarThemeView: View {
    var sevenDays = ["일", "월", "화", "수", "목", "금", "토"]
    let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 0, alignment: .center), count: 7)
    
    @ObservedObject private var dateModel = DateModel.shared
    
    @ObservedObject var viewModel: WidgetSettingModel
    
    private let capsuleButtonWidth: CGFloat = 60
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text(dateModel.selectedDate.toString().hyphenToDot())
                    .font(.system(size: 21))
                    .bold()
                    .padding(.horizontal)
                    .contentTransition(.identity)
                
                Spacer()
                
                HStack {
                    Button {
                        dateModel.setThisMonth()
                    } label: {
                        Image(systemName: "square")
                            .font(.caption)
                    }
                    .frame(width: 30, height: 30)
                    .background(
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .fill(WidgetTheme(rawValue: viewModel.themeColor)!.color)
                    )
                    .padding(.horizontal, 5)
                    .buttonStyle(.plain)
                    .foregroundStyle(Color.white)
                    .bold()
                    
                    HStack(spacing: 0) {
                        Button {
                            dateModel.setPriorMonth()
                        } label: {
                            RoundedRectangle(cornerRadius: capsuleButtonWidth / 4, style: .continuous)
                                .fill(WidgetTheme(rawValue: viewModel.themeColor)!.color)
                                .frame(width: capsuleButtonWidth, height: capsuleButtonWidth / 2)
                                .offset(x: capsuleButtonWidth / 4)
                                .clipped()
                                .offset(x: -capsuleButtonWidth / 4)
                                .frame(width: capsuleButtonWidth / 2)
                                .overlay {
                                    Image(systemName: "lessthan")
                                        .font(.caption)
                                        .foregroundStyle(Color.white)
                                        .bold()
                                        .offset(x: -capsuleButtonWidth / 8)
                                }
                        }
                        .frame(width: 30, height: 30)
                        .buttonStyle(.plain)
                        
                        Rectangle()
                            .fill(WidgetTheme(rawValue: viewModel.themeColor)!.color)
                            .frame(width: 1, height: capsuleButtonWidth / 2)
                            .overlay {
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width: 1, height: capsuleButtonWidth / 4)
                            }
                        
                        Button {
                            dateModel.setNextMonth()
                        } label: {
                            RoundedRectangle(cornerRadius: capsuleButtonWidth / 4, style: .continuous)
                                .fill(WidgetTheme(rawValue: viewModel.themeColor)!.color)
                                .frame(width: capsuleButtonWidth, height: capsuleButtonWidth / 2)
                                .offset(x: -capsuleButtonWidth / 4)
                                .clipped()
                                .offset(x: capsuleButtonWidth / 4)
                                .frame(width: capsuleButtonWidth / 2)
                                .overlay {
                                    Image(systemName: "greaterthan")
                                        .font(.caption)
                                        .foregroundStyle(Color.white)
                                        .bold()
                                        .offset(x: capsuleButtonWidth / 8)
                                }
                        }
                        .frame(width: 30, height: 30)
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 15)
            
            LazyVGrid(columns: columns) {                
                if let days = CalendarBuilder.generateMonth(for: dateModel.selectedDate) {
                    ForEach(0..<days.count, id: \.self) { index in
                        let day = days[index]
                        if  day.isInCurrentMonth {
                            CalendarDateView(dateDate: day.date, date: day.date.get(component: .day), index: index, viewModel: viewModel)
                                .aspectRatio(contentMode: .fill)
                        } else {
                            EmptyCalendarDateView()
                        }
                    }
                }
            }
            
            
            ZStack {
                Rectangle()
                    .fill(Color.clear)
                    .overlay(alignment: .top) {
                        EventDetailView()
                    }
            }
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 20)
        
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    //    CalendarThemeView(viewModel: .init())
    ContentView()
}

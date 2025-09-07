//
//  CalendarView.swift
//  CaletteWidget
//
//  Created by yeri on 2/2/25.
//

import WidgetKit
import SwiftUI

struct CalendarView: View {
    var entry: Provider.Entry
    
    let CalendarColumns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 0, alignment: .center), count: 7)
    
    let gridColumns: Int = 7
    let gridRows: Int = 8
    
    @ObservedObject var dateVM: DateViewModel = DateViewModel()
    @ObservedObject var viewModel: CalendarSettingViewModel
    
    var body: some View {
        GeometryReader { geometry in
            let cellWidth = geometry.size.width / CGFloat(gridColumns)
            let cellHeight = geometry.size.height / CGFloat(gridRows)
            
//            ZStack {
//                // 배경 grid
//                ForEach(0..<gridRows, id: \.self) { row in
//                    ForEach(0..<gridColumns, id: \.self) { col in
//                        Rectangle()
//                            .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
//                            .frame(width: cellWidth, height: cellHeight)
//                            .position(
//                                x: CGFloat(col) * cellWidth + cellWidth / 2,
//                                y: CGFloat(row) * cellHeight + cellHeight / 2
//                            )
//                    }
//                }
            VStack(spacing: 0) {
                ZStack {
                    Button(intent: EmptyIntent()) {
                        Rectangle()
                            .fill(.clear)
                    }
                    .buttonStyle(.plain)
                    
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Text(dateVM.selectedDate.toString().hyphenToDot())
                                .font(.system(size: 21))
                                .foregroundStyle(Color.textBlack)
                                .bold()
                                .padding(.horizontal)
                                .contentTransition(.identity)
                                .frame(
                                    width: 4.0 * cellWidth,
                                    height: 1.0 * cellHeight
                                )
                            
                            if viewModel.isLunarCalendar {
                                MoonPhaseView(lunarDay: Int(dateVM.selectedDate.lunarDate.toStringD())!)
                                    .frame(
                                        width: 1.0 * cellWidth,
                                        height: 1.0 * cellHeight
                                    )
                            }

                            Spacer()
                            
                            Button(intent: TodayIntent()) {
                                Image(systemName: "square")
                                    .frame(width: cellWidth * 0.8, height: cellHeight * 0.8)
                                    .font(.caption)
                                    .foregroundStyle(Color.white)
                                    .bold()
                                    .background(WidgetTheme(rawValue: viewModel.themeColor)!.color)
                            }
                            .clipShape(Circle())
                            .buttonStyle(.plain)
                            .frame(
                                width: 1.0 * cellWidth,
                                height: 1.0 * cellHeight
                            )
                        }
                        .frame(
                            width: 7.0 * cellWidth,
                            height: 1.0 * cellHeight
                        )
                        
                        LazyVGrid(columns: CalendarColumns, spacing: 0) {
                            if let days = CalendarBuilder.generateMonth(for: dateVM.selectedDate) {
                                ForEach(0..<days.count, id: \.self) { index in
                                    let day = days[index]
                                    if day.isInCurrentMonth {
                                        WidgetCalendarDateView(dateDate: day.date, index: index, dateVM: dateVM, viewModel: viewModel)
                                            .frame(width: cellWidth, height: cellHeight)
                                    } else {
                                        Rectangle()
                                            .fill(Color.clear)
                                            .frame(width: cellWidth, height: cellHeight)
                                    }
                                }
                            }
                        }
                    }
                }
                
                WidgetEventTitleView(cellWidth: cellWidth, cellHeight: cellHeight, dateVM: dateVM)
            }
//            }//ZStack
        }
    }
}

#Preview(as: .systemLarge) {
    CaletteWidget()
} timeline: {
    CalendarEntry(date: .now, selectedDate: .now)
    CalendarEntry(date: .now, selectedDate: .now)
}


struct MoonPhaseView: View {
    let lunarDay: Int
    
    var body: some View {
        Image(moonImage(for: lunarDay))
            .resizable()
    }
    
    func moonImage(for day: Int) -> String {
        switch day {
        case 1...3, 28...30:
            return "imgMoon0"
        case 4...7:
            return "imgMoon1"
        case 8...10:
            return "imgMoon2"
        case 11...14:
            return "imgMoon3"
        case 15:
            return "imgMoon4"
        case 16...19:
            return "imgMoon5"
        case 20...22:
            return "imgMoon6"
        case 23...27:
            return "imgMoon7"
        default:
            return "imgMoon0"
        }
    }
}

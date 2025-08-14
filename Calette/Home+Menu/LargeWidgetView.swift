//
//  LargeWidgetView.swift
//  Calette
//
//  Created by yeri on 6/29/25.
//

import SwiftUI

// MARK: - 위젯 뷰 (systemLarge)
struct LargeWidgetView: View {
    let CalendarColumns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 0, alignment: .center), count: 7)
    
    let gridColumns: Int = 7
    let gridRows: Int = 8
    
    @ObservedObject private var dateModel = DateModel.shared
    @ObservedObject var viewModel: WidgetSettingModel
    
    var body: some View {
        GeometryReader { geometry in
            let cellWidth = geometry.size.width / CGFloat(gridColumns)
            let cellHeight = geometry.size.height / CGFloat(gridRows)
            
            ZStack {
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
                    // row 1
                    HStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Text(dateModel.selectedDate.toString().hyphenToDot())
                                .font(.system(size: 21))
                                .bold()
                                .padding(.horizontal)
                                .contentTransition(.identity)
                            Spacer()
                        }
                        .frame(
                            width: 4.0 * cellWidth,
                            height: 1.0 * cellHeight
                        )
//                        .background(Color.black.opacity(0.1))
                        
                        HStack(spacing: 8) {
                            Button {
                                dateModel.setThisMonth()
                            } label: {
                                Image(systemName: "square")
                                    .frame(width: cellWidth * 0.8, height: cellHeight * 0.8)
                                    .font(.caption)
                                    .foregroundStyle(Color.white)
                                    .bold()
                                    .background(WidgetTheme(rawValue: viewModel.themeColor)!.color)
                            }
                            .clipShape(Circle())
                            
                            HStack(spacing: 0) {
                                Button {
                                    dateModel.setPriorMonth()
                                } label: {
                                    Image(systemName: "lessthan")
                                        .frame(width: cellWidth * 0.6, height: cellHeight * 0.7)
                                        .font(.caption)
                                        .foregroundStyle(Color.white)
                                        .bold()
                                        .padding(.horizontal, 8)
                                        .background(WidgetTheme(rawValue: viewModel.themeColor)!.color)
                                }
                                
                                Rectangle()
                                    .fill(WidgetTheme(rawValue: viewModel.themeColor)!.color)
                                    .frame(width: 1, height: cellHeight * 0.7)
                                    .overlay {
                                        Rectangle()
                                            .fill(Color.white)
                                            .frame(width: 1, height: cellHeight * 0.4)
                                    }
                                
                                Button {
                                    dateModel.setNextMonth()
                                } label: {
                                    Image(systemName: "greaterthan")
                                        .frame(width: cellWidth * 0.6, height: cellHeight * 0.7)
                                        .font(.caption)
                                        .foregroundStyle(Color.white)
                                        .bold()
                                        .padding(.horizontal, 8)
                                        .background(WidgetTheme(rawValue: viewModel.themeColor)!.color)
                                }
                            }
                            .clipShape(Capsule())
                        }
                        .frame(
                            width: 3.0 * cellWidth,
                            height: 1.0 * cellHeight
                        )
                        
                    }
                    
                    // 날짜
                    LazyVGrid(columns: CalendarColumns, spacing: 0) {
                        if let days = CalendarBuilder.generateMonth(for: dateModel.selectedDate) {
                            ForEach(0..<days.count, id: \.self) { index in
                                let day = days[index]
                                if day.isInCurrentMonth {
                                    CalendarDateView(dateDate: day.date, date: day.date.get(component: .day), index: index, viewModel: viewModel)
                                        .frame(width: cellWidth, height: cellHeight)
//                                        .aspectRatio(contentMode: .fill)
                                } else {
                                    Rectangle()
                                        .fill(Color.clear)
                                        .frame(width: cellWidth, height: cellHeight)
                                }
                            }
                        }
                    }
                    
                    // 이벤트 디테일
                    EventTitleView(cellWidth: cellWidth, cellHeight: cellHeight)
                }
                
            }
        }
    }
}

#Preview {
    ContentView()
}

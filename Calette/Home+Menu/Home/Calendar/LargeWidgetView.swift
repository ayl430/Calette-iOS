//
//  LargeWidgetView.swift
//  Calette
//
//  Created by yeri on 6/29/25.
//

import SwiftUI

struct LargeWidgetView: View {

    let gridColumns: Int = 7
    let gridRows: Int = 8

    @EnvironmentObject var dateVM: DateViewModel
    @EnvironmentObject var calendarSettingVM: CalendarSettingsViewModel

    @State private var currentPage: Int = 1
    @State private var isTransitioning: Bool = false
    @State private var contentOpacity: Double = 1.0
    @State private var displayedDate: Date = Date()
    @State private var hintOffset: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            let cellWidth = geometry.size.width / CGFloat(gridColumns)
            let cellHeight = geometry.size.height / CGFloat(gridRows)

            // 표시용 날짜 기준으로 계산 (전환 중 레이아웃 유지)
            let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: displayedDate.startOfMonth) ?? displayedDate
            let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: displayedDate.startOfMonth) ?? displayedDate

            // 현재 달의 캘린더 줄 수 계산 (7 - 이벤트 줄 수)
            let currentMonthRows = 7 - CalendarBuilder.maxEventTitleViewLines(date: displayedDate)

            VStack(spacing: 0) {
                // 날짜 + 오늘 버튼
                HStack(spacing: 0) {
                    Text(dateVM.selectedDate.toString().hyphenToDot())
                        .font(.system(size: 21))
                        .foregroundStyle(DesignSystem.Colors.primary)
                        .bold()
                        .padding(.horizontal)
                        .contentTransition(.numericText())
                        .animation(.easeInOut(duration: 0.2), value: displayedDate)
                        .frame(
                            width: 4.0 * cellWidth,
                            height: 1.0 * cellHeight
                        )
                    
                    if calendarSettingVM.isLunarCalendar {
                        MoonPhaseView(lunarDay: Int(dateVM.selectedDate.lunarDate.toStringD())!)
                            .frame(
                                width: 1.0 * cellWidth,
                                height: 1.0 * cellHeight
                            )
                    }

                    Spacer()
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            dateVM.setThisMonth()
                            displayedDate = Date()
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .fill(calendarSettingVM.currentTheme.buttonGradient)

                            Circle()
                                .fill(DesignSystem.Gradient.buttonHighlight)
                                .allowsHitTesting(false)

                            Circle()
                                .strokeBorder(DesignSystem.Gradient.buttonBorder, lineWidth: 1)
                                .allowsHitTesting(false)

                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        .frame(width: cellWidth * 0.72, height: cellHeight * 0.72)
                        .shadow(color: DesignSystem.Shadow.card, radius: 4, x: 0, y: 3)
                        .shadow(color: calendarSettingVM.currentTheme.glowColor, radius: DesignSystem.Shadow.buttonGlowRadius, x: 0, y: DesignSystem.Shadow.buttonGlowY)
                    }
                    .frame(
                        width: 1.0 * cellWidth,
                        height: 1.0 * cellHeight
                    )
                }
                .frame(
                    width: 7.0 * cellWidth,
                    height: 1.0 * cellHeight
                )
                
                // 캘린더(스와이프) + 이벤트 영역
                VStack(spacing: 0) {
                    TabView(selection: $currentPage) {
                        MonthGridView(targetDate: previousMonth, cellWidth: cellWidth, cellHeight: cellHeight, fixedRows: currentMonthRows)
                            .tag(0)

                        MonthGridView(targetDate: displayedDate, cellWidth: cellWidth, cellHeight: cellHeight, fixedRows: currentMonthRows)
                            .tag(1)

                        MonthGridView(targetDate: nextMonth, cellWidth: cellWidth, cellHeight: cellHeight, fixedRows: currentMonthRows)
                            .tag(2)
                    }
                    .frame(height: CGFloat(currentMonthRows) * cellHeight)
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .background(ClearPageBackground())
                    .offset(x: hintOffset)
                    .onChange(of: currentPage) { oldValue, newValue in
                        handlePageChange(newValue: newValue)
                    }

                    EventTitleView(cellWidth: cellWidth, cellHeight: cellHeight)
                }
                .background(Color.clear)
                .opacity(contentOpacity)
            }
            .background(Color.clear)
        }
        .onAppear {
            displayedDate = dateVM.selectedDate
        }
        .onReceive(NotificationCenter.default.publisher(for: .showSwipeHint)) { _ in
            showSwipeHint()
        }
    }
    
    private func handlePageChange(newValue: Int) {
        guard !isTransitioning && newValue != 1 else { return }

        isTransitioning = true

        // 1. 페이드 아웃
        withAnimation(.easeOut(duration: 0.08)) {
            contentOpacity = 0
        }

        // 2. 데이터 변경 및 페이지 리셋
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            if newValue == 0 {
                dateVM.setPriorMonth()
                displayedDate = displayedDate.priorMonth.startOfMonth
            } else if newValue == 2 {
                dateVM.setNextMonth()
                displayedDate = displayedDate.nextMonth.startOfMonth
            }
            currentPage = 1

            // 3. 페이드 인
            withAnimation(.easeIn(duration: 0.1)) {
                contentOpacity = 1
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isTransitioning = false
            }
        }
    }
    
    private func showSwipeHint() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeOut(duration: 0.1)) {
                hintOffset = -10
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.15)) {
                    hintOffset = 10
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation(.easeOut(duration: 0.1)) {
                        hintOffset = 0
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

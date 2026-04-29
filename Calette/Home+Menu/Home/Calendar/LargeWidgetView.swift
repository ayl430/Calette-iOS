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

    @State private var displayedDate: Date = Date()
    @State private var dragOffset: CGFloat = 0
    @State private var isAnimating: Bool = false
    @State private var hintOffset: CGFloat = 0

    private let swipeAnimation: Animation = .interactiveSpring(response: 0.32, dampingFraction: 0.85)
    private let swipeDuration: Double = 0.32

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
                                width: 1.0 * cellHeight,
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
                    let calendarWidth = geometry.size.width

                    HStack(spacing: 0) {
                        MonthGridView(targetDate: previousMonth, cellWidth: cellWidth, cellHeight: cellHeight, fixedRows: currentMonthRows)
                            .frame(width: calendarWidth)

                        MonthGridView(targetDate: displayedDate, cellWidth: cellWidth, cellHeight: cellHeight, fixedRows: currentMonthRows)
                            .frame(width: calendarWidth)

                        MonthGridView(targetDate: nextMonth, cellWidth: cellWidth, cellHeight: cellHeight, fixedRows: currentMonthRows)
                            .frame(width: calendarWidth)
                    }
                    .offset(x: -calendarWidth + dragOffset + hintOffset)
                    .frame(width: calendarWidth, height: CGFloat(currentMonthRows) * cellHeight, alignment: .leading)
                    .clipped()
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 8)
                            .onChanged { value in
                                guard !isAnimating else { return }
                                // 가로 우세한 제스처만 따라가기 (세로 스크롤과의 충돌 방지)
                                guard abs(value.translation.width) > abs(value.translation.height) else { return }
                                dragOffset = rubberBand(value.translation.width, limit: calendarWidth)
                            }
                            .onEnded { value in
                                guard !isAnimating else { return }
                                handleDragEnd(
                                    translation: value.translation.width,
                                    predictedEnd: value.predictedEndTranslation.width,
                                    width: calendarWidth
                                )
                            }
                    )

                    EventTitleView(cellWidth: cellWidth, cellHeight: cellHeight)
                }
                .background(Color.clear)
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
    
    private enum PageDirection { case prev, next }

    private func handleDragEnd(translation: CGFloat, predictedEnd: CGFloat, width: CGFloat) {
        let threshold = width * 0.25
        // 빠른 플릭은 predictedEnd, 느린 드래그는 translation 기준
        let decisionValue = abs(predictedEnd) > abs(translation) ? predictedEnd : translation

        if decisionValue <= -threshold {
            commitPageChange(direction: .next, width: width)
        } else if decisionValue >= threshold {
            commitPageChange(direction: .prev, width: width)
        } else {
            withAnimation(swipeAnimation) {
                dragOffset = 0
            }
        }
    }

    private func commitPageChange(direction: PageDirection, width: CGFloat) {
        isAnimating = true
        let target: CGFloat = direction == .next ? -width : width

        withAnimation(swipeAnimation) {
            dragOffset = target
        }

        // 스냅 애니메이션 완료 후 데이터 갱신 + offset 리셋을 한 프레임에 (애니메이션 없이)
        DispatchQueue.main.asyncAfter(deadline: .now() + swipeDuration) {
            var transaction = Transaction()
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                switch direction {
                case .next:
                    dateVM.setNextMonth()
                    displayedDate = displayedDate.nextMonth.startOfMonth
                case .prev:
                    dateVM.setPriorMonth()
                    displayedDate = displayedDate.priorMonth.startOfMonth
                }
                dragOffset = 0
            }
            isAnimating = false
        }
    }

    /// 양 끝에서 살짝 저항감 있는 드래그 (러버밴딩)
    private func rubberBand(_ value: CGFloat, limit: CGFloat) -> CGFloat {
        guard limit > 0 else { return value }
        if abs(value) <= limit { return value }
        let excess = abs(value) - limit
        let damped = limit + excess / (1 + excess / limit) * 0.55
        return value < 0 ? -damped : damped
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

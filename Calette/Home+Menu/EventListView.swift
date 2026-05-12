//
//  EventListView.swift
//  Calette
//
//  Created by yeri on 7/31/25.
//

import SwiftUI
import EventKit

struct EventListView: View {

    @EnvironmentObject var coordinator: Coordinator
    @EnvironmentObject var dateVM: DateViewModel
    @EnvironmentObject var calendarSettingVM: CalendarSettingsViewModel

    @Environment(\.presentationMode) var presentationMode

    @StateObject private var scopeVM = EventListScopeViewModel()

    @State var showAddSheet: Bool = false

    /// 날짜 슬라이드 transition 방향만을 위한 시각용 상태 (비즈니스 로직 무관).
    @State private var lastNavDirection: DateNavDirection = .next

    /// Swipe drag 진행량. 제스처 중에만 변하며 commit/cancel 시 0으로 복귀.
    @State private var dragOffset: CGFloat = 0

    /// 최초 진입 시 swipe affordance 학습용 micro hint phase (0 → 1 → 0).
    @State private var hintPhase: CGFloat = 0
    @State private var didRunHint: Bool = false

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 24) {
                    dateNavigationPanel
                        .padding(.horizontal)

                    ScopeSegmentedControl(
                        selection: $scopeVM.scope,
                        accentColor: calendarSettingVM.accentColor
                    )
                    .padding(.horizontal)

                    Group {
                        switch scopeVM.scope {
                        case .day:
                            daySingleContent
                        case .week, .month:
                            groupedContent
                        }
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))

                    addEventButton
                }
                .padding(.top, 20)
                .padding(.bottom, 80)
                .animation(.easeInOut(duration: 0.22), value: scopeVM.scope)
            }
            .background {
                CosmicBackgroundView()
            }
            .toolbarBackground(DesignSystem.Colors.background, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                            Text("홈")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundStyle(calendarSettingVM.accentColor)
                    }
                }
            }
            .sheet(isPresented: $showAddSheet, onDismiss: {
                scopeVM.reload()
                dateVM.setEvent()
            }) {
                AddEvent(dateVM: dateVM)
            }
            .onAppear {
                scopeVM.update(anchor: dateVM.selectedDate, firstWeekday: calendarSettingVM.firstDayOfWeek)
                scopeVM.reload()
                scrollToAnchorIfNeeded(proxy: proxy, animated: false)
            }
            .onChange(of: dateVM.selectedDate) { _, newValue in
                scopeVM.update(anchor: newValue, firstWeekday: calendarSettingVM.firstDayOfWeek)
                scrollToAnchorIfNeeded(proxy: proxy, animated: true)
            }
            .onChange(of: calendarSettingVM.firstDayOfWeek) {
                scopeVM.update(anchor: dateVM.selectedDate, firstWeekday: calendarSettingVM.firstDayOfWeek)
            }
            .onChange(of: scopeVM.scope) {
                scrollToAnchorIfNeeded(proxy: proxy, animated: true)
            }
            .onChange(of: dateVM.eventDays) {
                scopeVM.reload()
            }
        }
    }

    // MARK: - Scroll helpers

    /// week/month 모드일 때 anchor 날짜로 스크롤.
    private func scrollToAnchorIfNeeded(proxy: ScrollViewProxy, animated: Bool) {
        guard scopeVM.scope != .day else { return }
        let anchorID = scopeVM.anchorDate.startOfDay

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            if animated {
                withAnimation(.easeInOut(duration: 0.25)) {
                    proxy.scrollTo(anchorID, anchor: .top)
                }
            } else {
                proxy.scrollTo(anchorID, anchor: .top)
            }
        }
    }

    // MARK: - 날짜 네비게이션 패널 (Floating swipeable date carousel)

    private enum DateNavDirection {
        case prev, next
    }

    private enum PeekSide {
        case leading, trailing
    }

    private static let dragCommitDistance: CGFloat = 56
    private static let dragCommitVelocity: CGFloat = 320
    private static let dragElasticLimit: CGFloat = 140
    private static let peekBaseOffset: CGFloat = 142

    /// 좌우 swipe로 날짜를 탐색하는 floating glass carousel.
    /// - center: 현재 선택된 날짜 (hero focal)
    /// - sides: 이전/다음 날짜의 ghost preview (edge peek)
    /// - interaction: drag gesture만 사용 (chevron 등 explicit UI 없음)
    /// 비즈니스 로직(snapToDay/selectedDate 등)은 chevron 시절과 100% 동일.
    private var dateNavigationPanel: some View {
        ZStack {
            peekDateView(date: dateVM.selectedDate.priorDay, side: .leading)
            peekDateView(date: dateVM.selectedDate.nextDay, side: .trailing)

            dateFocalContent
                .offset(x: dragOffset)
                .scaleEffect(centerScale)
                .opacity(centerOpacity)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .background {
            RoundedRectangle(cornerRadius: DesignSystem.Layout.cardRadius)
                .fill(
                    LinearGradient(
                        colors: [
                            DesignSystem.Colors.Glass.tintTop.opacity(0.92),
                            DesignSystem.Colors.Glass.tintBottom.opacity(0.78)
                        ],
                        startPoint: .top, endPoint: .bottom
                    )
                )
        }
        .overlay {
            // Atmospheric inner highlight — softens the panel top.
            RoundedRectangle(cornerRadius: DesignSystem.Layout.cardRadius)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.06),
                            Color.white.opacity(0.0)
                        ],
                        startPoint: .top, endPoint: .center
                    )
                )
                .allowsHitTesting(false)
        }
        .overlay {
            RoundedRectangle(cornerRadius: DesignSystem.Layout.cardRadius)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            DesignSystem.Colors.Glass.borderTop.opacity(0.85),
                            DesignSystem.Colors.Glass.borderBottom.opacity(0.5)
                        ],
                        startPoint: .top, endPoint: .bottom
                    ),
                    lineWidth: 1
                )
                .allowsHitTesting(false)
        }
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Layout.cardRadius))
        .shadow(color: DesignSystem.Shadow.card, radius: DesignSystem.Shadow.cardRadius, x: 0, y: DesignSystem.Shadow.cardY)
        .contentShape(Rectangle())
        .gesture(swipeGesture)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text(dateVM.selectedDate.toString().hyphenToDot()))
        .accessibilityHint(Text("좌우로 스와이프해 날짜를 이동합니다"))
        .accessibilityAction(named: Text("이전 날짜")) { commit(direction: .prev) }
        .accessibilityAction(named: Text("다음 날짜")) { commit(direction: .next) }
        .onAppear { runHintIfNeeded() }
    }

    // MARK: - Center hero (focal)

    /// 슬라이드 + 페이드 transition을 위해 selectedDate에 id를 묶은 focal block.
    /// 기존 transition 로직(edgeIn/edgeOut + asymmetric move+opacity)을 그대로 유지.
    private var dateFocalContent: some View {
        let edgeIn: Edge = (lastNavDirection == .next) ? .trailing : .leading
        let edgeOut: Edge = (lastNavDirection == .next) ? .leading : .trailing

        return VStack(spacing: 8) {
            Text(dateVM.selectedDate.toString().hyphenToDot())
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(DesignSystem.Colors.primary)
                .kerning(0.6)
                .shadow(color: Color.black.opacity(0.35), radius: 8, x: 0, y: 2)

            HStack(spacing: 5) {
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(DesignSystem.Colors.secondary.opacity(0.85))
                Text(dateVM.selectedDate.lunarDate.toStringMdd())
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(DesignSystem.Colors.secondary.opacity(0.85))
            }
        }
        .frame(maxWidth: .infinity)
        .id(dateVM.selectedDate.toString())
        .transition(.asymmetric(
            insertion: .move(edge: edgeIn).combined(with: .opacity),
            removal: .move(edge: edgeOut).combined(with: .opacity)
        ))
    }

    // MARK: - Edge peek (neighboring date ghosts)

    /// 양옆에 subtle하게 비치는 이웃 날짜.
    /// drag 진행 방향 쪽 peek은 점점 선명해지며 carousel 감각을 강화.
    private func peekDateView(date: Date, side: PeekSide) -> some View {
        let isLeading = (side == .leading)
        let baseX = isLeading ? -Self.peekBaseOffset : Self.peekBaseOffset

        // drag가 이 peek 쪽으로 향할 때만 0→1로 강조.
        let directionalDrag: CGFloat = isLeading ? max(0, dragOffset) : max(0, -dragOffset)
        let pull = min(directionalDrag / Self.dragElasticLimit, 1.0)

        // 진입 시 1회 hint: peek가 바깥쪽으로 살짝 더 멀어졌다 돌아옴 (호흡 느낌).
        let hintShift: CGFloat = (isLeading ? -1 : 1) * hintPhase * 5

        return Text(date.toString().hyphenToDot())
            .font(.system(size: 15, weight: .medium, design: .rounded))
            .foregroundStyle(DesignSystem.Colors.primary)
            .kerning(0.3)
            .opacity(0.16 + pull * 0.55 + Double(hintPhase) * 0.18)
            .scaleEffect(0.74 + pull * 0.14)
            .blur(radius: max(0, 1.6 - pull * 1.6))
            .offset(x: baseX + dragOffset * 0.42 + hintShift)
            .allowsHitTesting(false)
    }

    // MARK: - Center transform (drag-driven)

    private var centerScale: CGFloat {
        // 매우 미세한 shrink — 끌리는 느낌만 제공.
        1.0 - min(abs(dragOffset) / 600, 0.05)
    }

    private var centerOpacity: Double {
        1.0 - min(Double(abs(dragOffset)) / 260, 0.32)
    }

    // MARK: - Swipe gesture

    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 6)
            .onChanged { value in
                dragOffset = elasticTranslation(value.translation.width)
            }
            .onEnded { value in
                let translation = value.translation.width
                let velocity = value.predictedEndTranslation.width - translation
                let direction: DateNavDirection? = {
                    if translation < -Self.dragCommitDistance || velocity < -Self.dragCommitVelocity {
                        return .next
                    } else if translation > Self.dragCommitDistance || velocity > Self.dragCommitVelocity {
                        return .prev
                    }
                    return nil
                }()

                if let dir = direction {
                    commit(direction: dir)
                } else {
                    // Threshold 미달 — elastic snap back.
                    withAnimation(.spring(response: 0.38, dampingFraction: 0.78)) {
                        dragOffset = 0
                    }
                }
            }
    }

    /// drag translation에 탄성 저항을 적용 — limit을 넘으면 35% 비율로 감속.
    private func elasticTranslation(_ raw: CGFloat) -> CGFloat {
        let limit = Self.dragElasticLimit
        if abs(raw) <= limit { return raw }
        let excess = abs(raw) - limit
        let damped = limit + excess * 0.35
        return raw >= 0 ? damped : -damped
    }

    // MARK: - Commit (기존 chevron 로직과 동일)

    /// 비즈니스 로직은 기존 chevron 버튼과 완전히 동일.
    /// 시각 transition 방향만 lastNavDirection으로 갱신.
    private func commit(direction: DateNavDirection) {
        let newDate = (direction == .prev)
            ? dateVM.selectedDate.priorDay
            : dateVM.selectedDate.nextDay
        lastNavDirection = direction
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        withAnimation(.spring(response: 0.42, dampingFraction: 0.86)) {
            scopeVM.snapToDay(anchor: newDate, firstWeekday: calendarSettingVM.firstDayOfWeek)
            dateVM.selectedDate = newDate
            dragOffset = 0
        }
    }

    // MARK: - First-time swipe hint

    /// 최초 1회만 peek 날짜가 살짝 호흡하며 swipe 가능함을 암시.
    private func runHintIfNeeded() {
        guard !didRunHint else { return }
        didRunHint = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
            withAnimation(.easeInOut(duration: 0.7)) {
                hintPhase = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                withAnimation(.easeInOut(duration: 0.6)) {
                    hintPhase = 0
                }
            }
        }
    }

    // MARK: - 일(day) 모드 컨텐츠 (기존 동작 유지)

    @ViewBuilder
    private var daySingleContent: some View {
        let daySection = scopeVM.sections.first

        if let section = daySection, !section.isEmpty {
            VStack(spacing: 16) {
                if !section.holidays.isEmpty {
                    holidaySection(holidays: section.holidays)
                }
                myEventsSection(normalEvents: section.normalEvents)
            }
            .padding(.horizontal)
        } else {
            emptyStateView
        }
    }

    private func holidaySection(holidays: [EKEvent]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "flag.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(DesignSystem.Colors.holiday)
                Text("공휴일")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(DesignSystem.Colors.primary)
            }
            .padding(.leading, 4)

            ForEach(holidays, id: \.self) { holiday in
                eventCard(
                    title: holiday.title ?? "공휴일",
                    time: "하루 종일",
                    accentColor: DesignSystem.Colors.holiday,
                    destination: nil
                )
            }
        }
    }

    private func myEventsSection(normalEvents: [EKEvent]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "calendar")
                    .font(.system(size: 14))
                    .foregroundStyle(calendarSettingVM.accentColor)
                Text("나의 일정")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(DesignSystem.Colors.primary)
            }
            .padding(.leading, 4)

            if normalEvents.isEmpty {
                emptyMyEventsView
            } else {
                ForEach(normalEvents, id: \.self) { event in
                    eventRow(event: event)
                }
            }
        }
    }

    // MARK: - 주/월 모드 컨텐츠 (날짜별 그룹)

    @ViewBuilder
    private var groupedContent: some View {
        let visibleSections = scopeVM.sections.filter { !$0.isEmpty || scopeVM.isAnchorDay($0.date) }

        if visibleSections.isEmpty {
            emptyStateView
        } else {
            LazyVStack(spacing: 20) {
                ForEach(visibleSections) { section in
                    daySectionView(section: section)
                        .id(section.date.startOfDay)
                }
            }
            .padding(.horizontal)
        }
    }

    private func daySectionView(section: EventDaySection) -> some View {
        let isAnchor = scopeVM.isAnchorDay(section.date)

        return VStack(alignment: .leading, spacing: 12) {
            dateSectionHeader(date: section.date, isAnchor: isAnchor)

            if section.isEmpty {
                anchorEmptyHint
            } else {
                ForEach(section.holidays, id: \.self) { holiday in
                    eventCard(
                        title: holiday.title ?? "공휴일",
                        time: "하루 종일",
                        accentColor: DesignSystem.Colors.holiday,
                        destination: nil
                    )
                }
                ForEach(section.normalEvents, id: \.self) { event in
                    eventRow(event: event)
                }
            }
        }
        .padding(.vertical, isAnchor ? 12 : 0)
        .padding(.horizontal, isAnchor ? 10 : 0)
        .background {
            if isAnchor {
                RoundedRectangle(cornerRadius: 20)
                    .fill(calendarSettingVM.accentColor.opacity(0.10))
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(calendarSettingVM.accentColor.opacity(0.35), lineWidth: 1)
                    }
            }
        }
    }

    private func dateSectionHeader(date: Date, isAnchor: Bool) -> some View {
        HStack(spacing: 8) {
            Text("\(date.get(component: .month))월 \(date.get(component: .day))일")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(DesignSystem.Colors.primary)

            Text(date.toStringEEE())
                .font(.system(size: 13))
                .foregroundStyle(DesignSystem.Colors.secondary)

            if isAnchor {
                Text("선택")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(
                        Capsule().fill(calendarSettingVM.accentColor.opacity(0.85))
                    )
            }

            Spacer()
        }
        .padding(.leading, 4)
    }

    private var anchorEmptyHint: some View {
        HStack(spacing: 10) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 18))
                .foregroundStyle(calendarSettingVM.accentColor.opacity(0.6))
            Text("이 날짜에는 일정이 없습니다")
                .font(.system(size: 13))
                .foregroundStyle(DesignSystem.Colors.secondary)
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(DesignSystem.Colors.border, lineWidth: 1)
        }
    }

    // MARK: - 빈 상태 뷰 (전체)

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(DesignSystem.Colors.surface.opacity(0.6))
                    .frame(width: 120, height: 120)

                Image(systemName: "calendar.badge.plus")
                    .font(.system(size: 50))
                    .foregroundStyle(calendarSettingVM.accentColor)
            }
            .padding(.top, 40)

            VStack(spacing: 8) {
                Text("등록된 일정이 없습니다")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(DesignSystem.Colors.primary)

                Text("새로운 일정을 추가해보세요")
                    .font(.system(size: 14))
                    .foregroundStyle(DesignSystem.Colors.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }

    // MARK: - 나의 일정 빈 상태 (day 모드 전용)

    private var emptyMyEventsView: some View {
        HStack(spacing: 12) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 24))
                .foregroundStyle(calendarSettingVM.accentColor.opacity(0.6))

            VStack(alignment: .leading, spacing: 4) {
                Text("등록된 일정이 없습니다")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(DesignSystem.Colors.primary)

                Text("일정을 추가해보세요")
                    .font(.system(size: 13))
                    .foregroundStyle(DesignSystem.Colors.secondary)
            }

            Spacer()
        }
        .padding(DesignSystem.Layout.cardPaddingV)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [DesignSystem.Colors.Glass.tintTop, DesignSystem.Colors.Glass.tintBottom],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .allowsHitTesting(false)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(
                    LinearGradient(
                        colors: [DesignSystem.Colors.Glass.borderTop, DesignSystem.Colors.Glass.borderBottom],
                        startPoint: .top, endPoint: .bottom
                    ),
                    lineWidth: 1
                )
                .allowsHitTesting(false)
        }
    }

    // MARK: - 이벤트 시간 문자열

    private func eventTimeString(for event: EKEvent) -> String {
        let isAllDay = event.isAllDay
        let startTime = event.startDate.toStringAhmm()
        let endTime = event.endDate.toStringAhmm()
        let isOneDayEvent = event.startDate.startOfDay == event.endDate.startOfDay
        let oneDayEventTime = isAllDay ? "하루 종일" : "\(startTime) - \(endTime)"
        let notOneDayEventTime = isAllDay
            ? "\(event.startDate.toString().hyphenToDot()) - \(event.endDate.toString().hyphenToDot())"
            : "\(event.startDate.toString().hyphenToDot()) \(startTime) \n- \(event.endDate.toString().hyphenToDot()) \(endTime)"
        return isOneDayEvent ? oneDayEventTime : notOneDayEventTime
    }

    @ViewBuilder
    private func eventRow(event: EKEvent) -> some View {
        let title = event.title ?? "일정"
        let time = eventTimeString(for: event)
        if let eventId = event.eventIdentifier {
            eventCard(
                title: title,
                time: time,
                accentColor: calendarSettingVM.accentColor,
                destination: AnyView(EventDetailView(eventId: eventId))
            )
        } else {
            eventCard(
                title: title,
                time: time,
                accentColor: calendarSettingVM.accentColor,
                destination: nil
            )
        }
    }

    // MARK: - 일정 카드 컴포넌트

    @ViewBuilder
    private func eventCard(
        title: String,
        time: String,
        accentColor: Color,
        destination: AnyView?
    ) -> some View {
        let content = HStack(spacing: 0) {
            // 좌측 accent 바
            Rectangle()
                .fill(accentColor)
                .frame(width: DesignSystem.Layout.accentBarWidth)

            // 내용
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(DesignSystem.Typography.body1())
                        .fontWeight(.semibold)
                        .foregroundStyle(DesignSystem.Colors.primary)
                        .lineLimit(1)

                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 11))
                        Text(time)
                            .font(DesignSystem.Typography.body2())
                    }
                    .foregroundStyle(DesignSystem.Colors.secondary)
                }

                Spacer()

                if destination != nil {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(DesignSystem.Colors.secondary.opacity(0.6))
                }
            }
            .padding(.horizontal, DesignSystem.Layout.cardPaddingH)
            .padding(.vertical, DesignSystem.Layout.cardPaddingV)
        }
        .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Layout.cardRadius))
        .overlay {
            RoundedRectangle(cornerRadius: DesignSystem.Layout.cardRadius)
                .fill(
                    LinearGradient(
                        colors: [DesignSystem.Colors.Glass.tintTop, DesignSystem.Colors.Glass.tintBottom],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .allowsHitTesting(false)
        }
        .overlay {
            RoundedRectangle(cornerRadius: DesignSystem.Layout.cardRadius)
                .strokeBorder(
                    LinearGradient(
                        colors: [DesignSystem.Colors.Glass.borderTop, DesignSystem.Colors.Glass.borderBottom],
                        startPoint: .top, endPoint: .bottom
                    ),
                    lineWidth: 1
                )
                .allowsHitTesting(false)
        }
        .shadow(color: DesignSystem.Shadow.card, radius: DesignSystem.Shadow.cardRadius, x: 0, y: DesignSystem.Shadow.cardY)
        .contentShape(Rectangle())
        
        if let dest = destination {
            NavigationLink(destination: dest) {
                content
            }
            .buttonStyle(CardButtonStyle())
        } else {
            content
        }
    }

    // MARK: - 추가 버튼

    private var addEventButton: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                showAddSheet.toggle()
            }
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 16, weight: .semibold))
                Text("일정 추가")
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background {
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                calendarSettingVM.accentColor.opacity(0.7),
                                calendarSettingVM.accentColor.opacity(0.4)
                            ],
                            startPoint: .top, endPoint: .bottom
                        )
                    )
            }
            .overlay {
                Capsule()
                    .fill(DesignSystem.Colors.Glass.tintTop)
                    .allowsHitTesting(false)
            }
            .overlay {
                Capsule()
                    .strokeBorder(DesignSystem.Gradient.buttonBorder, lineWidth: 1)
                    .allowsHitTesting(false)
            }
            .shadow(color: calendarSettingVM.accentColor.opacity(0.3), radius: 12, x: 0, y: 4)
        }
        .buttonStyle(ScaleButtonStyle())
        .padding(.horizontal)
    }
}


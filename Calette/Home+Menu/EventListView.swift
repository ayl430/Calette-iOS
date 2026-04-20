//
//  EventListView.swift
//  Calette
//
//  Created by yeri on 7/31/25.
//

import SwiftUI

struct EventListView: View {
    
    @EnvironmentObject var coordinator: Coordinator
    @EnvironmentObject var dateVM: DateViewModel
    @EnvironmentObject var calendarSettingVM: CalendarSettingsViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var showAddSheet: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                dateHeaderCard
                    .padding(.horizontal)

                if EventManager.shared.fetchAllEvents(date: dateVM.selectedDate).count == 0 {
                    emptyStateView
                } else {
                    eventsListView
                }

                addEventButton
            }
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
        .background {
            CosmicBackgroundView()
        }
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
        .sheet(isPresented: $showAddSheet) {
            AddEvent(dateVM: dateVM)
        }
    }
    
    // MARK: - 날짜 헤더 카드
    
    private var dateHeaderCard: some View {
        VStack(spacing: 12) {
            // 양력 날짜
            Text(dateVM.selectedDate.toString().hyphenToDot())
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(DesignSystem.Colors.primary)

            // 음력 날짜
            HStack(spacing: 6) {
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(DesignSystem.Colors.secondary)
                Text(dateVM.selectedDate.lunarDate.toStringMdd())
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(DesignSystem.Colors.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
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
    }

    // MARK: - 빈 상태 뷰
    
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
    
    // MARK: - 일정 리스트 뷰
    
    private var eventsListView: some View {
        VStack(spacing: 16) {
            if EventManager.shared.isHoliday(dateVM.selectedDate) {
                holidaySection
            }
            
            myEventsSection
        }
        .padding(.horizontal)
    }
    
    private var holidaySection: some View {
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
            
            let holidays = EventManager.shared.fetchAllHolidays(on: dateVM.selectedDate)
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
    
    
    private var myEventsSection: some View {
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
            
            let normalEvents = EventManager.shared.fetchAllNormalEvents(on: dateVM.selectedDate)
            if normalEvents.isEmpty {
                emptyMyEventsView
            } else {
                ForEach(normalEvents, id: \.self) { event in
                    let eventTitle = event.title ?? "일정"
                    let isAllDay = event.isAllDay
                    let startTime = event.startDate.toStringAhmm()
                    let endTime = event.endDate.toStringAhmm()
                    let isOneDayEvent = event.startDate.startOfDay == event.endDate.startOfDay
                    let oneDayEventTime = isAllDay ? "하루 종일" : "\(startTime) - \(endTime)"
                    let notOneDayEventTime = isAllDay
                    ? "\(event.startDate.toString().hyphenToDot()) - \(event.endDate.toString().hyphenToDot())"
                    : "\(event.startDate.toString().hyphenToDot()) \(startTime) \n- \(event.endDate.toString().hyphenToDot()) \(endTime)"
                    
                    if let eventId = event.eventIdentifier {
                        eventCard(
                            title: eventTitle,
                            time: isOneDayEvent ? oneDayEventTime : notOneDayEventTime,
                            accentColor: calendarSettingVM.accentColor,
                            destination: AnyView(EventDetailView(eventId: eventId))
                        )
                    } else {
                        eventCard(
                            title: eventTitle,
                            time: isOneDayEvent ? oneDayEventTime : notOneDayEventTime,
                            accentColor: calendarSettingVM.accentColor,
                            destination: nil
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - 나의 일정 빈 상태
    
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

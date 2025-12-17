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
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var showAddSheet: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "FEF9B7"), Color(hex: "FFF4D6"), Color(hex: "FFE5B4")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    dateHeaderCard
                        .padding(.horizontal)
                        .padding(.top)
                    
                    if EventManager.shared.fetchAllEvents(date: dateVM.selectedDate).count == 0 {
                        emptyStateView
                    } else {
                        eventsListView
                    }
                    
                    addEventButton
                        .padding(.bottom, 30)
                }
            }
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
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "DD6464"), Color(hex: "FF8080")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
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
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: "DD6464"), Color(hex: "FF8080")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )

            // 음력 날짜
            HStack(spacing: 6) {
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(Color(hex: "9C9E9E"))
                Text(dateVM.selectedDate.lunarDate.toStringMdd())
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color(hex: "9C9E9E"))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.7))
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        }
    }
    
    // MARK: - 빈 상태 뷰
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "FFE5B4").opacity(0.5), Color.white.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: "calendar.badge.plus")
                    .font(.system(size: 50))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "DD6464"), Color(hex: "FF8080")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .padding(.top, 40)
            
            VStack(spacing: 8) {
                Text("등록된 일정이 없습니다")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.textBlack)
                
                Text("새로운 일정을 추가해보세요")
                    .font(.system(size: 14))
                    .foregroundStyle(Color(hex: "8A898E"))
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
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "FF6B6B"), Color(hex: "FF8E8E")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                Text("공휴일")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.textBlack)
            }
            .padding(.leading, 4)
            
            let holidays = EventManager.shared.fetchAllHolidays(on: dateVM.selectedDate)
            ForEach(holidays, id: \.self) { holiday in
                eventCard(
                    title: holiday.title ?? "공휴일",
                    time: "하루 종일",
                    colorStart: Color(hex: "FF6B6B"),
                    colorEnd: Color(hex: "FF8E8E"),
                    icon: "flag.fill",
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
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "6B9AFF"), Color(hex: "8EB4FF")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                Text("나의 일정")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.textBlack)
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
                            colorStart: Color(hex: "6B9AFF"),
                            colorEnd: Color(hex: "8EB4FF"),
                            icon: "calendar",
                            destination: AnyView(EventDetailView(eventId: eventId))
                        )
                    } else {
                        eventCard(
                            title: eventTitle,
                            time: isOneDayEvent ? oneDayEventTime : notOneDayEventTime,
                            colorStart: Color(hex: "6B9AFF"),
                            colorEnd: Color(hex: "8EB4FF"),
                            icon: "calendar",
                            destination: nil
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - 나의 일정 빈 상태
    
    private var emptyMyEventsView: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "calendar.badge.exclamationmark")
                    .font(.system(size: 24))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "6B9AFF").opacity(0.5), Color(hex: "8EB4FF").opacity(0.5)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("등록된 일정이 없습니다")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Color.textBlack)
                    
                    Text("일정을 추가해보세요")
                        .font(.system(size: 13))
                        .foregroundStyle(Color(hex: "8A898E"))
                }
                
                Spacer()
            }
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "6B9AFF").opacity(0.05), Color(hex: "8EB4FF").opacity(0.03)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [Color(hex: "6B9AFF").opacity(0.2), Color(hex: "8EB4FF").opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    }
            }
        }
    }
    
    // MARK: - 일정 카드 컴포넌트
    
    @ViewBuilder
    private func eventCard(
        title: String,
        time: String,
        colorStart: Color,
        colorEnd: Color,
        icon: String,
        destination: AnyView?
    ) -> some View {
        let content = HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [colorStart.opacity(0.15), colorEnd.opacity(0.08)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [colorStart, colorEnd],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.textBlack)
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 11))
                    Text(time)
                        .font(.system(size: 13))
                }
                .foregroundStyle(Color(hex: "8A898E"))
            }
            
            Spacer()
            
            if destination != nil {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color(hex: "D0D0D0"))
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.8))
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
        }
        
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
            .foregroundStyle(
                LinearGradient(
                    colors: [Color(hex: "DD6464"), Color(hex: "FF8080")],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background {
                Capsule()
                    .fill(.white.opacity(0.9))
                    .shadow(color: Color(hex: "DD6464").opacity(0.2), radius: 8, x: 0, y: 4)
                    .overlay {
                        Capsule()
                            .strokeBorder(
                                LinearGradient(
                                    colors: [Color(hex: "DD6464").opacity(0.3), Color(hex: "FF8080").opacity(0.2)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: 1.5
                            )
                    }
            }
        }
        .buttonStyle(ScaleButtonStyle())
        .padding(.horizontal)
    }
}

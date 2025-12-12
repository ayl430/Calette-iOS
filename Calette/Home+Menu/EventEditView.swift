//
//  EventEditView.swift
//  Calette
//
//  Created by yeri on 8/5/25.
//

import SwiftUI
import EventKit

struct EventEditView: View {
    let eventId: String
    @State var showAlertView: Bool = false
    
    @EnvironmentObject var dateVM: DateViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "FEF9B7"), Color(hex: "FFF4D6"), Color(hex: "FFE5B4")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    if let event = EventManager.shared.fetchEvent(withId: eventId) {
                        eventHeaderCard(event: event)
                            .padding(.horizontal)
                            .padding(.top)
                        
                        detailInfoCard(event: event)
                            .padding(.horizontal)
                        
                        deleteButton
                            .padding(.horizontal)
                            .padding(.bottom, 30)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text(dateVM.selectedDate.toString().hyphenToDot())
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
        .overlay {
            if showAlertView {
                modernAlertView
            }
        }
    }
    
    // MARK: - 이벤트 헤더 카드
    
    private func eventHeaderCard(event: EKEvent) -> some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "6B9AFF").opacity(0.15), Color(hex: "8EB4FF").opacity(0.08)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                
                Image(systemName: "calendar")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "6B9AFF"), Color(hex: "8EB4FF")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(event.title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color.textBlack)
                    .lineLimit(2)
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 11))
                        Text(dateVM.selectedDate.toString().hyphenToDot() + " " + dateVM.selectedDate.toStringEEE())
                            .font(.system(size: 13))
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 11))
                        Text(event.isAllDay ? "하루 종일" : "\(event.startDate.toStringAhmm()) - \(event.endDate.toStringAhmm())")
                            .font(.system(size: 13))
                    }
                }
                .foregroundStyle(Color(hex: "8A898E"))
            }
            
            Spacer()
        }
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.8))
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        }
    }
    
    // MARK: - 상세 정보 카드
    
    private func detailInfoCard(event: EKEvent) -> some View {
        VStack(spacing: 0) {
            infoRow(
                icon: "bell.fill",
                title: "알림",
                value: event.hasAlarms ? alarmsString(event.alarms) : "없음",
                isLast: false
            )
            
            Divider()
                .padding(.leading, 60)
            
            infoRowWithMultiline(
                icon: "note.text",
                title: "메모",
                value: event.hasNotes ? event.notes!.byCharWrapping : "없음"
            )
        }
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(0.8))
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        }
    }
    
    private func infoRow(icon: String, title: String, value: String, isLast: Bool) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "6B9AFF").opacity(0.15), Color(hex: "8EB4FF").opacity(0.08)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "6B9AFF"), Color(hex: "8EB4FF")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color(hex: "020202"))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 15))
                .foregroundStyle(Color(hex: "8A8A8A"))
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 12)
    }
    
    private func infoRowWithMultiline(icon: String, title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "6B9AFF").opacity(0.15), Color(hex: "8EB4FF").opacity(0.08)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "6B9AFF"), Color(hex: "8EB4FF")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color(hex: "020202"))
                
                Spacer()
            }
            
            Text(value)
                .font(.system(size: 15))
                .foregroundStyle(Color(hex: "8A8A8A"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 48)
        }
        .padding(.vertical, 12)
    }
    
    // MARK: - 삭제 버튼
    
    private var deleteButton: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                showAlertView.toggle()
            }
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "trash.fill")
                    .font(.system(size: 16, weight: .semibold))
                Text("일정 삭제")
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
    }
    
    // MARK: - 모던 알럿 뷰
    
    private var modernAlertView: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        showAlertView = false
                    }
                }
            
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(Color.red.opacity(0.1))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(Color.red)
                }
                .padding(.top, 8)
                
                VStack(spacing: 8) {
                    Text("일정 삭제")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Color(hex: "020202"))
                    
                    Text("일정을 삭제하겠습니까?")
                        .font(.system(size: 15))
                        .foregroundStyle(Color(hex: "8A898E"))
                }
                
                VStack(spacing: 12) {
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            EventManager.shared.deleteEvent(withId: eventId)
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        Text("삭제")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.red)
                            .clipShape(Capsule())
                    }
                    
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            showAlertView = false
                        }
                    } label: {
                        Text("취소")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color(hex: "8A898E"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.white)
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(24)
            .background {
                RoundedRectangle(cornerRadius: 24)
                    .fill(.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
            }
            .padding(.horizontal, 40)
            .transition(.scale.combined(with: .opacity))
        }
    }
    
    // MARK: - Helper Functions
    
    private func alarmsString(_ alarms: [EKAlarm]?) -> String {
        alarms?
            .map { offsetToString($0.relativeOffset) }
            .joined(separator: ", ") ?? "없음"
    }
    
    func offsetToString(_ offset: TimeInterval?) -> String {
        guard let offset = offset else {
            return "없음"
        }
        
        let alarmMapping: [TimeInterval: String] = [
            0: "이벤트 당일",
            -300: "5분 전",
            -900: "15분 전",
            -1800: "30분 전",
            -3600: "1시간 전",
            -7200: "2시간 전",
            -86400: "1일 전",
            -172800: "2일 전",
            -604800: "1주일 전"
        ]
        
        return alarmMapping[offset] ?? "\(Int(offset / 60))분 전"
    }
}

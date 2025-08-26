//
//  EventEditView.swift
//  Calette
//
//  Created by yeri on 8/5/25.
//

import SwiftUI

struct EventEditView: View {
    let eventId: String
    @State var showAlertView: Bool = false
    
    @ObservedObject private var dateModel = DateModel.shared
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let event = EventManager.shared.fetchEvent(withId: eventId) {
                    HStack {
                        Rectangle()
                            .frame(width: 2, height: 60)
                            .foregroundStyle(Color.blue)
                        VStack(alignment: .leading) {
                            Text(event.title)
                                .foregroundStyle(Color.textBlack)
                                .bold()
                                .padding(.bottom, 2)
                            
                            Text(dateModel.selectedDate.toString().hyphenToDot() + " " + dateModel.selectedDate.toStringEEE())
                                .font(.footnote)
                                .foregroundStyle(Color(hex: "8A898E"))
                            Text(event.isAllDay ? "하루 종일" : event.startDate.toStringAhmm() + " - " + event.endDate.toStringAhmm())
                                .font(.footnote)
                                .foregroundStyle(Color(hex: "8A898E"))
                        }
                    }
                    .padding(.top, 30)
                    .padding(.bottom, 40)
                    
                    HStack {
                        Text("알림")
                            .font(.callout)
                            .foregroundStyle(Color(hex: "020202"))
                        Spacer()
                        
                        let alarmsString = event.alarms?
                            .map { offsetToString($0.relativeOffset) }
                            .joined(separator: ", ") ?? "없음"
                        Text(event.hasAlarms ? alarmsString : "없음")
                            .font(.callout)
                            .foregroundStyle(Color(hex: "8A8A8A"))
                    }
                    .padding(.bottom, 10)
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color(hex: "D0D0D0")),
                        alignment: .bottom
                    )
                    .padding(.bottom)
                    
                    VStack(alignment: .leading) {
                        Text("메모")
                            .font(.callout)
                            .foregroundStyle(Color(hex: "020202"))
                        Text(event.hasNotes ? event.notes!.byCharWrapping : "없음")
                            .font(.callout)
                            .foregroundStyle(Color(hex: "8A8A8A"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.bottom, 10)
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color(hex: "D0D0D0")),
                        alignment: .bottom
                    )
                    
                }
            }
            
            
            Button {
                showAlertView.toggle()
            } label: {
                Text("일정 삭제하기").font(.headline)
                    .foregroundStyle(.white)
                    .bold()
                    .padding(.horizontal, 40)
                    .padding(.vertical, 10)
                    .background(Color(hex: "DD6464"))
                    .clipShape(Capsule())
            }
            .padding()
            
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .navigationBarBackButtonHidden() // 스크롤시 이거 배경색 체크
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color.caletteDefault)
                        Text(dateModel.selectedDate.toString().hyphenToDot())
                            .foregroundColor(Color.caletteDefault)
                    }
                }
            }
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button {
//
//                    } label: {
//                        Text("편집")
//                            .foregroundColor(Color.caletteDefault)
//                    }
//                }
        }
        .scrollContentBackground(.hidden) // 시스템 배경색 삭제
        .background(Color(hex: "FEF9B7"))
        .overlay {
            if showAlertView {
                AlertView(message: "일정을 삭제하겠습니까?", tapped: {
                    EventManager.shared.deleteEvent(withId: eventId)
                    presentationMode.wrappedValue.dismiss()
                }, showAlertView: $showAlertView)
            }
        }
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

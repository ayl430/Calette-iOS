//
//  EventDetailView.swift
//  JustCalendar
//
//  Created by yeri on 7/31/25.
//

import SwiftUI

struct EventDetailView: View {
    
    @EnvironmentObject var coordinator: Coordinator
    
    @ObservedObject private var dateModel = DateModel.shared
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var showAddEventView: Bool = false
    
    var body: some View {
        VStack {
            VStack {
                Text(dateModel.selectedDate.toString().hyphenToDot())
                    .font(.largeTitle)
                    .bold()
                Text("🌙 \(dateModel.selectedDate.lunarDate.toStringMdd())") //
                    .font(.title3)
                    .foregroundStyle(Color(hex: "9C9E9E"))
            }
            .padding()
            
            if EventManager.shared.fetchAllEvents(date: dateModel.selectedDate).count == 0 {
                Text("등록된 일정이 없습니다.")
                    .padding(.vertical)
                    .padding(.top).padding(.top).padding(.top)
                
                Button {
                    showAddEventView.toggle()
                } label: {
                    Text("일정 등록하기").font(.headline)
                        .foregroundStyle(.white)
                        .bold()
                        .padding(.horizontal, 40)
                        .padding(.vertical, 10)
                        .background(Color(hex: "DD6464"))
                        .clipShape(Capsule())
                }
                Spacer()
            } else {
                List {
                    if dateModel.isHoliday(on: dateModel.selectedDate) {
                        Section(header: Text("공휴일")) {
                            let holidays = EventManager.shared.fetchAllHolidays(on: dateModel.selectedDate)
                            ForEach(holidays, id: \.self) {
                                let holidayTitle = $0.title ?? "공휴일"
                                let holidaytime = "하루 종일"
                                HStack() {
                                    Rectangle()
                                        .frame(width: 2, height: 30)
                                        .foregroundStyle(Color.red)
                                    VStack(alignment: .leading) {
                                        Text(holidayTitle)
                                        Text(holidaytime)
                                            .font(.footnote)
                                            .foregroundStyle(Color(hex: "8A898E"))
                                    }
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("나의 일정")) {
                        let normalEvents = EventManager.shared.fetchAllNormalEvents(on: dateModel.selectedDate)
                        ForEach(normalEvents, id: \.self) {
                            let eventTitle = $0.title ?? "일정"
                            let isAllDay = $0.isAllDay
                            let eventStartTime = $0.startDate.toStringAhmm()
                            let eventEndTime = $0.endDate.toStringAhmm()
                            let id: String = $0.eventIdentifier
                            
                            NavigationLink(destination: EventEditView(eventId: id)) {
                                HStack {
                                    Rectangle()
                                        .frame(width: 2, height: 30)
                                        .foregroundStyle(Color.blue)
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(eventTitle)
                                        Text(isAllDay ? "하루 종일" : eventStartTime + " - " + eventEndTime)
                                            .font(.footnote)
                                            .foregroundStyle(Color(hex: "8A898E"))
                                    }
                                }
                            }
                        }
                    }
                }
                Button {
                    showAddEventView.toggle()
                } label: {
                    Text("일정 추가하기").font(.headline)
                        .foregroundStyle(.white)
                        .bold()
                        .padding(.horizontal, 40)
                        .padding(.vertical, 10)
                        .background(Color(hex: "DD6464"))
                        .clipShape(Capsule())
                }
                .padding(.bottom)
            }
        }
        .frame(maxWidth: .infinity)
        .scrollContentBackground(.hidden) // 시스템 배경색 삭제
        .background(Color(hex: "FEF9B7"))
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color.justDefaultColor)
                        Text("홈")
                            .foregroundColor(Color.justDefaultColor)
                    }
                }
            }
        }
        .sheet(isPresented: $showAddEventView) {
            AddEvent()
        }
    }
}

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
                            .foregroundColor(Color.justDefaultColor)
                        Text(dateModel.selectedDate.toString().hyphenToDot())
                            .foregroundColor(Color.justDefaultColor)
                    }
                }
            }
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button {
//
//                    } label: {
//                        Text("편집")
//                            .foregroundColor(Color.justDefaultColor)
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

//#Preview(body: {
//    EventEditView()
//})


extension String {
    var byCharWrapping: Self {
        self.split(separator: "").joined(separator: "\u{200B}")
    }
}

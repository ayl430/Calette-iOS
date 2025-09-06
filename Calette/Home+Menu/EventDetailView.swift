//
//  EventDetailView.swift
//  Calette
//
//  Created by yeri on 7/31/25.
//

import SwiftUI

struct EventDetailView: View {
    
    @EnvironmentObject var coordinator: Coordinator
    @EnvironmentObject var dateVM: DateViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var showAddEventView: Bool = false
    
    var body: some View {
        VStack {
            VStack {
                Text(dateVM.selectedDate.toString().hyphenToDot())
                    .font(.largeTitle)
                    .foregroundStyle(Color.textBlack)
                    .bold()
                Text("🌙 \(dateVM.selectedDate.lunarDate.toStringMdd())")
                    .font(.title3)
                    .foregroundStyle(Color(hex: "9C9E9E"))
            }
            .padding()
            
            if EventManager.shared.fetchAllEvents(date: dateVM.selectedDate).count == 0 {
                Text("등록된 일정이 없습니다.")
                    .foregroundStyle(Color.textBlack)
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
                    if EventManager.shared.isHoliday(dateVM.selectedDate) {
                        Section(header: Text("공휴일")) {
                            let holidays = EventManager.shared.fetchAllHolidays(on: dateVM.selectedDate)
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
                        let normalEvents = EventManager.shared.fetchAllNormalEvents(on: dateVM.selectedDate)
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
                            .foregroundColor(Color.caletteDefault)
                        Text("홈")
                            .foregroundColor(Color.caletteDefault)
                    }
                }
            }
        }
        .sheet(isPresented: $showAddEventView) {
            AddEvent()
        }
    }
}

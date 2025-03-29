//
//  FirstDayView.swift
//  JustCalendar
//
//  Created by yeri on 2/22/25.
//

import SwiftUI

struct FirstDayView: View {
    @ObservedObject var viewModel: WidgetSettingModel
    
    var body: some View {
            List {
                Button {
                    viewModel.firstDayOfWeek = 1
                    viewModel.setFirstDayOfWeek(day: 1)
                } label: {
                    HStack {
                        Text("일요일")
                            .foregroundStyle(Color.black)
                        Spacer()
                        if viewModel.firstDayOfWeek == 1 {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                
                Button {
                    viewModel.firstDayOfWeek = 2
                    viewModel.setFirstDayOfWeek(day: 2)
                } label: {
                    HStack {
                        Text("월요일")
                            .foregroundStyle(Color.black)
                        Spacer()
                        if viewModel.firstDayOfWeek == 2 {
                            Image(systemName: "checkmark")                            
                        }
                    }
                }
            }
        
    }
}

#Preview {
//    FirstDayView()
}

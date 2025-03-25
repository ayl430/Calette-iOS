//
//  FirstDayView.swift
//  JustCalendar
//
//  Created by yeri on 2/22/25.
//

import SwiftUI

struct FirstDayView: View {
    
    var body: some View {
            List {
                Button {
                    print("tapped")
                } label: {
                    HStack {
                        Text("일요일")
                            .foregroundStyle(Color.black)
                        Spacer()
                        Image(systemName: "checkmark")
                    }
                }
                
                Button {
                    print("tapped")
                } label: {
                    HStack {
                        Text("월요일")
                            .foregroundStyle(Color.black)
                        Spacer()
                        Image(systemName: "checkmark")
                    }
                }
            }
        
    }
}

#Preview {
    FirstDayView()
}

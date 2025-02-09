//
//  EventDetailView.swift
//  JustCalendar
//
//  Created by yeri on 2/3/25.
//

import SwiftUI

struct EventDetailView: View {
    var body: some View {
    
        HStack {
            Text("|")
            Text("이벤트 1")
//            Text("8:00 - 10:00")
            
            Spacer()
//            Text("+")
//            Text(">")
        }
        .font(.system(size: 10))
        .padding(.vertical, 5)
    }
}

#Preview {
    EventDetailView()
}

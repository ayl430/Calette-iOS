//
//  EventEmptyView.swift
//  JustCalendar
//
//  Created by yeri on 7/10/25.
//

import SwiftUI

struct EventEmptyView: View {
    var body: some View {
        Image(systemName: "tree")
            .frame(width: 30, height: 30)
            .foregroundStyle(Color.gray)
            .padding(.leading, 10)
    }
}

#Preview {
    EventEmptyView()
}

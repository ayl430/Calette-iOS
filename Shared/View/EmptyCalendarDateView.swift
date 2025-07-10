//
//  EmptyCalendarDateView.swift
//  JustCalendar
//
//  Created by yeri on 7/10/25.
//

import SwiftUI

struct EmptyCalendarDateView: View {
    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(width: 40, height: 30)
    }
}

#Preview {
    EmptyCalendarDateView()
}

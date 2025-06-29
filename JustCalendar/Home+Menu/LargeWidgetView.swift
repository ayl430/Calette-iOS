//
//  LargeWidgetView.swift
//  JustCalendar
//
//  Created by yeri on 6/29/25.
//

import SwiftUI

// MARK: - 위젯 뷰 (systemLarge)
struct LargeWidgetView: View {
    let height: CGFloat
    
    var body: some View {
        CalendarThemeView(viewModel: WidgetSettingModel())
            .padding()
            .background(Color(hex: "EFEFF0"))
            .frame(height: height)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 25)
    }
}

//
//  LunarDayView.swift
//  JustCalendar
//
//  Created by yeri on 2/22/25.
//

import SwiftUI

struct LunarDayView: View {
    
    @State var isOn: Bool = false
    
    var body: some View {
        List {
            Section(footer: Text("선택한 날짜 하단에 음력 날짜가 표시됩니다").padding(.vertical, 5)) {
                HStack {
                    Toggle("음력 표시", isOn: $isOn)
                }
            }
        }
        
    }
}

#Preview {
    LunarDayView()
}

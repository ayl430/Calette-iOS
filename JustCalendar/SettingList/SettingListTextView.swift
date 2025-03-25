//
//  SettingListTextView.swift
//  JustCalendar
//
//  Created by yeri on 2/22/25.
//

import SwiftUI

struct SettingListTextView: View {
    
    var title: String = ""
    var text: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                Spacer()
                Text(text)
            }
        }
        
    }
}

#Preview {
    SettingListTextView()
}

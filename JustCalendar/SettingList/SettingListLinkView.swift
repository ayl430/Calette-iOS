//
//  SettingListLinkView.swift
//  JustCalendar
//
//  Created by yeri on 2/22/25.
//

import SwiftUI

struct SettingListLinkView: View {
    enum LinkType {
        case theme
        case FirstDay
        case lunarDay
        case developer
    }
    
    var title: String = ""
    var link: LinkType
    
    var body: some View {
        NavigationLink {
            switch link {
            case .theme:
                WidgetThemesView()
            case .FirstDay:
                FirstDayView()
            case .lunarDay:
                LunarDayView()
            case .developer:
                DeveloperEmailView()
            }
        } label: {
            Text(title)
        }
    }
}

#Preview {
//    SettingListLinkView()
}

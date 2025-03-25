//
//  MainView.swift
//  JustCalendar
//
//  Created by yeri on 1/30/25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    SettingListLinkView(title: "위젯 테마", link: .theme)
                    SettingListLinkView(title: "첫번째 요일", link: .FirstDay)
                    SettingListLinkView(title: "음력 표시", link: .lunarDay)
                } header: {
                    Text("설정")
                }
                Section {
//                    Text("저스트 위젯 알아보기")
                    SettingListLinkView(title: "개발자 문의", link: .developer)
                    SettingListTextView(title: "버전 정보", text: "v 1.0.0")
                } header: {
                    Text("앱 정보")
                }
            }
            .navigationTitle("저스트 위젯")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.justDefaultColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}
        

#Preview {
    MainView()
}

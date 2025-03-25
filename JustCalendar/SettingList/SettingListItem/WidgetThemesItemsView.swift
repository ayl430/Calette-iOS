//
//  WidgetThemesItemsView.swift
//  JustCalendar
//
//  Created by yeri on 2/22/25.
//

import SwiftUI

/*
 isOnTheme -> userDefaults에 themeColor가 있으면 true, "" false (초기값 false)
 처음 toggle -> false
 toggle 선택 -> true -> userDefaults에 themeColor를 yellow로 기본값
 */
struct WidgetThemesItemsView: View {
    @ObservedObject var viewModel: WidgetSettingModel
//    @AppStorage(WidgetSettings.Keys.themeColorKey, store: UserDefaults.shared) var color: String = "justDefaultColor"
    
    var body: some View {
        List {
            Section {
                Toggle("테마 적용", isOn: $viewModel.isOnTheme)
                    .onChange(of: viewModel.isOnTheme) {
                        if viewModel.isOnTheme {
                            viewModel.setTheme(color: WidgetTheme.justYellow.name)
                        } else {
                            viewModel.setTheme(color: WidgetTheme.justDefaultColor.name)
                        }
                    }
            }
            
            if viewModel.isOnTheme {
                Section {
                    ForEach(WidgetTheme.allCases, id: \.self) { color in
                        if color != .justDefaultColor {
                            Button {
                                viewModel.themeColor = color.name
                                viewModel.setTheme(color: color.name)
                            } label: {
                                HStack {
                                    Image(systemName: "checkmark.circle")
                                        .padding(.horizontal, 10)
                                    Spacer()
                                    if viewModel.themeColor == color.name {
                                        Text(color.name)
                                            .bold()
                                    } else {
                                        Text(color.name)
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            }
            
        }
    }
}

#Preview {
//    WidgetThemesItemsView()
}

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
            Section(footer: Text("테마 적용을 끄면 기본 테마가 적용됩니다")) {
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
                    
                }
                
                Section {
                    ForEach(WidgetTheme.allCases, id: \.self) { color in
                        if color != .justDefaultColor {
                            Button {
                                viewModel.themeColor = color.name
                                viewModel.setTheme(color: color.name)
                            } label: {
                                HStack {
                                    if viewModel.themeColor == color.name {
                                        WiegetThemesItemsChooseView(color: color)
                                        Spacer()
                                        Text(color.name)
                                            .foregroundStyle(Color.black)
                                            .bold()
                                    } else {
                                        WiegetThemesItemsChooseView(color: color)
                                            .opacity(0.3)
                                        Spacer()
                                        Text(color.name)
                                            .foregroundStyle(Color.black)
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
    WidgetThemesItemsView(viewModel: WidgetSettingModel())
}


struct WiegetThemesItemsChooseView: View {
    
    var color: WidgetTheme
    
    var body: some View {
        
        Image(systemName: "square")
            .font(.caption)
            .frame(width: 20, height: 20)
            .background(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(WidgetTheme(rawValue: color.name)!.color)
            )
            .foregroundStyle(Color.white)
            .bold()
    }
}

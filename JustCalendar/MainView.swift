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
            ZStack {
                ScrollView {
                    SettingLinkView(title: "위젯 테마", link: .theme)
                    SettingLinkView(title: "첫번째 요일", link: .FirstDay)
                    SettingLinkView(title: "음력 표시", link: .lunarDay)
                    SettingLinkView(title: "개발자 문의", link: .developer)
                    SettingTextView(title: "버전 정보", text: "v 1.0.0")
                }
                .padding(.vertical)
                .navigationTitle("저스트 위젯")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Color.yellow, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
            }
        }
    }
}

#Preview {
    MainView()
}


// MARK: - 각 리스트 뷰
struct SettingTextView: View {
    
    var title: String = ""
    var text: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                Spacer()
                Text(text)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            
            Divider()
                .padding(.horizontal, 10)
        }
        
    }
}

enum LinkType {
    case theme
    case FirstDay
    case lunarDay
    case developer
}

struct SettingLinkView: View {
    
    var title: String = ""
    var link: LinkType
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                Spacer()
                NavigationLink(">") {
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
                }
                .foregroundStyle(Color.brown)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            
            Divider()
                .padding(.horizontal, 10)
        }
    }
}


// MARK: - 리스트 이동 뷰
struct WidgetThemesView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
//        ZStack {
//            Color.white
        WidgetThemesItemsView()
//                .ignoresSafeArea(.all)
                .navigationBarBackButtonHidden()
                
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("이전")
                            }
                        }

                    }
                }
                
                
//        }
    }
}

//#Preview {
//    WidgetThemesView()
//}

struct WidgetThemesItemsView: View {
    
    @State var isOn: Bool = true
    
    var body: some View {
        
        List {
            Section {
                Toggle("테마 적용", isOn: $isOn)
            }
            
            if isOn {
                Section {
                    HStack {
                        Image(systemName: "checkmark.circle")
                            .padding(.horizontal, 10)
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 100, height: 100)
                        
                        Spacer()
                        Text("Default")
                        Spacer()
                    }
                }
                
            }
        }
        
    }
}


struct FirstDayView: View {
    
    var body: some View {
            List {
                Button {
                    print("tapped")
                } label: {
                    HStack {
                        Text("일요일")
                            .foregroundStyle(Color.black)
                        Spacer()
                        Image(systemName: "checkmark")
                    }
                }
                
                Button {
                    print("tapped")
                } label: {
                    HStack {
                        Text("월요일")
                            .foregroundStyle(Color.black)
                        Spacer()
                        Image(systemName: "checkmark")
                    }
                }
            }
        
    }
}



struct LunarDayView: View {
    
    @State var isOn: Bool = false
    
    var body: some View {
        List {
            Section(footer: Text("선택한 날짜 하단에 음력 날짜가 표시됩니다").padding(.vertical, 5)) {
                VStack {
                    HStack {
                        Spacer()
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: 150, height: 150)
                            .padding(10)
                            .overlay {
                                if isOn {
                                    Image(systemName: "moon").resizable()
                                        .padding()
                                } else {
                                    Image(systemName: "calendar").resizable()
                                        .padding()
                                }
                            }
                        Spacer()
                    }
                }
                HStack {
                    Toggle("음력 표시", isOn: $isOn)
                }
            }
        }
        
    }
}


struct DeveloperEmailView: View {
    var body: some View {
        Text("개발자 문의 메일")
    }
}

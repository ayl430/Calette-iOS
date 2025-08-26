//
//  HomeScreenView.swift
//  Calette
//
//  Created by yeri on 6/29/25.
//

import SwiftUI
#Preview {
    ContentView()
}

// MARK: - 홈 화면 뷰(앱 아이콘 + 위젯)
/* 버튼 별 인덱스
 1 2 3 4
       9
 5 6 7 8
 */
struct HomeScreenWithWidget: View {
    @Binding var selectedApp: AppIcon?
    @Binding var selectedIndex: Int
    
    @State var showAddEventView: Bool = false
    @State var showAlertView: Bool = false
    @State var showFaqView: Bool = false
    
    var body: some View {
        let screenSize = UIScreen.main.bounds.size
        let widgetSize = WidgetSizeProvider.size(for: .systemLarge)
        let spacing = (screenSize.width - widgetSize.width) / 2
        let iconSize = (widgetSize.width - spacing * 3) / 4
        
        ZStack {
            // 배경
            Image("imgBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: spacing) {
                // 위젯
                LargeWidgetView(viewModel: WidgetSettingModel())
                    .padding()
                    .background(Color(hex: "EFEFF0"))
                    .frame(width: widgetSize.width, height: widgetSize.height)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.top, 20 + safeAreaTopInset())

                 // 위젯 아래 앱아이콘 추가 //TBD
//            let columns = Array(repeating: GridItem(.fixed(iconSize), spacing: spacing), count: gridInfo.columns)
//                    LazyVGrid(columns: columns, spacing: spacing) {
//                        ForEach(0..<4, id: \.self) { index in
//                            let appIcon = AppIcon(index: index + 1, type: AppIconType.name(for: index), image: AppIconType.image(for: index))
//                            AppIconView(icon: appIcon, size: iconSize) {
//                                withAnimation(.easeInOut(duration: 0.25)) {
//                                    selectedApp = appIcon
//                                    selectedIndex = index + 1
//                                }
//                            }
//                            .anchorPreference(key: AppIconViewPreferenceKey.self, value: .bounds) { anchor in
//                                [index + 1: anchor]
//                            }
//                        }
//                    }
//                    .padding(.horizontal, spacing)
                
                Spacer()
                
                // 이벤트 추가
                HStack {
                    Spacer()
                    let appIcon = AppIcon(index: 9, type: AppIconType.name(for: 8), image: AppIconType.addEvent.image)
                    AddEventView(icon: appIcon, size: iconSize) {
                        selectedApp = appIcon
                        selectedIndex = 9
                        
                        if EventManager.shared.isFullAccess {
                            showAddEventView.toggle()
                        } else {
                            showAlertView.toggle()
                        }
                    }
                    .anchorPreference(key: AppIconViewPreferenceKey.self, value: .bounds) { anchor in
                        [9: anchor]
                    }
                    .sheet(isPresented: $showAddEventView) {
                        AddEvent()
                    }
                }
                .padding(.horizontal, spacing)
                .padding(.vertical, 2)
                
                // Dock
                HStack(spacing: spacing) {
                    ForEach(4..<8, id: \.self) { index in
                        let iconIndex = index + 1
                        let appIcon = AppIcon(index: iconIndex, type: AppIconType.name(for: index), image: AppIconType.image(for: index))
                        if iconIndex == 8 {
                            AppIconView(icon: appIcon, size: iconSize) {
                                selectedApp = appIcon
                                selectedIndex = iconIndex
                                
                                showFaqView.toggle()
                            }
                            .anchorPreference(key: AppIconViewPreferenceKey.self, value: .bounds) { anchor in
                                [iconIndex: anchor]
                            }
                            .sheet(isPresented: $showFaqView) {
                                FAQSheetView {
                                    showFaqView.toggle()
                                }
                            }
                        } else {
                            AppIconView(icon: appIcon, size: iconSize) {
                                selectedApp = appIcon
                                selectedIndex = iconIndex
                            }
                            .anchorPreference(key: AppIconViewPreferenceKey.self, value: .bounds) { anchor in
                                [iconIndex: anchor]
                            }
                        }
                    }
                }
                .padding()
                .background(
                    VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                )
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                .padding(.bottom, safeAreaBottomInset() + 5)
            }
            .frame(
                width: screenSize.width,
                height: screenSize.height
            )
            .ignoresSafeArea(edges: [.top, .bottom])
            
            if showAlertView {
                AlertView(message: "일정 추가를 위해 캘린더앱 접근 권한이 필요합니다", tapped: {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }, showAlertView: $showAlertView)
            }
        }
    }
    
    private func safeAreaBottomInset() -> CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return 0
        }
        return window.safeAreaInsets.bottom
    }
    
    private func safeAreaTopInset() -> CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return 0
        }
        return window.safeAreaInsets.top
    }
}

// MARK: - 배경 블러 뷰 (Dock용)
struct VisualEffectBlur: UIViewRepresentable {
    let blurStyle: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

#Preview(body: {
    MainView()
})

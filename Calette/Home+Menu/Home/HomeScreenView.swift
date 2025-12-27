//
//  HomeScreenView.swift
//  Calette
//
//  Created by yeri on 6/29/25.
//

import SwiftUI

// MARK: - 레이아웃 계산
struct HomeScreenLayout {
    let screenSize: CGSize
    let safeAreaInsets: EdgeInsets
    
    var widgetSize: CGSize {
        WidgetSizeProvider.size(for: .systemLarge)
    }
    
    var horizontalPadding: CGFloat {
        (screenSize.width - widgetSize.width) / 2
    }
    
    var iconSpacing: CGFloat {
        horizontalPadding * 0.95
    }
    
    var iconSize: CGFloat {
        (widgetSize.width - iconSpacing * 3) / 4
    }
    
    static let widgetCornerRadius: CGFloat = 20
    static let dockCornerRadius: CGFloat = 30
    static let shadowOpacity: Double = 0.05
    static let dockShadowOpacity: Double = 0.1
}

// MARK: - 배경 뷰
struct HomeScreenBackground: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("imgBackground")
                .resizable()
            
            LinearGradient(
                colors: [
                    Color(hex: "FEF9B7").opacity(0.4),
                    Color(hex: "FFF4D6").opacity(0.4),
                    Color(hex: "FFE5B4").opacity(0.4)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        .ignoresSafeArea()
    }
}

// MARK: - 위젯 컨테이너 뷰
struct WidgetContainer: View {
    let layout: HomeScreenLayout
    
    var body: some View {
        LargeWidgetView()
            .padding()
            .frame(width: layout.widgetSize.width, height: layout.widgetSize.height)
            .background {
                RoundedRectangle(cornerRadius: HomeScreenLayout.widgetCornerRadius)
                    .fill(Color(hex: "FFFFFE"))
                    .shadow(
                        color: Color.black.opacity(HomeScreenLayout.shadowOpacity),
                        radius: 10,
                        x: 0,
                        y: 5
                    )
            }
    }
}

// MARK: - 홈 화면 뷰(앱 아이콘 + 위젯)
/* 버튼 별 인덱스
 1 2 3 4
 9
 5 6 7 8
 */
struct HomeScreenView: View {
    @Binding var selectedApp: AppIcon?
    @Binding var selectedIndex: Int
    
    @EnvironmentObject var dateVM: DateViewModel
    
    @State private var showAddSheet = false
    @State private var showAlertView = false
    @State private var showFaqView = false
    
    var body: some View {
        GeometryReader { geometry in
            let layout = HomeScreenLayout(
                screenSize: geometry.size,
                safeAreaInsets: geometry.safeAreaInsets
            )
            
            ZStack() {
                HomeScreenBackground()
                
                VStack {
                    WidgetContainer(layout: layout)
                    
                    Spacer()
                    
                    AddEventView(
                        selectedApp: $selectedApp,
                        selectedIndex: $selectedIndex,
                        showAddSheet: $showAddSheet,
                        showAlertView: $showAlertView,
                        layout: layout
                    )
                    .padding(.horizontal, layout.horizontalPadding)
                    .padding(.bottom, layout.iconSpacing / 2)
                    
                    DockView(
                        selectedApp: $selectedApp,
                        selectedIndex: $selectedIndex,
                        showFaqView: $showFaqView,
                        layout: layout
                    )
                }
                .padding(.top)
                .padding(.bottom, 2)
                
                if showAlertView {
                    AlertView(
                        message: "일정 추가를 위해 캘린더앱 접근 권한이 필요합니다",
                        tapped: {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        },
                        showAlertView: $showAlertView
                    )
                }
            }
            .frame(width: layout.screenSize.width, height: layout.screenSize.height)
        }
        .sheet(isPresented: $showFaqView) {
            FAQSheetView {
                showFaqView = false
            }
        }
    }
}

#Preview {
    ContentView()
}

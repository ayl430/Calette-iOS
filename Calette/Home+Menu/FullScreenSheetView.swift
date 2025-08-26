//
//  FullScreenSheetView.swift
//  Calette
//
//  Created by yeri on 6/29/25.
//

import SwiftUI

// MARK: - sheet 뷰
struct AppFullScreenView: View {
    @Binding var appIcon: AppIcon?
    let position: CGPoint
    
    @Binding var showCover: Bool
    @Binding var showPopup: Bool
    
    let onTap: () -> Void
    
    var body: some View {
        if let appIcon = appIcon {
            if appIcon.index == 8 {
//                FAQSheetView(onCancelTapped: onTap)
            } else if appIcon.index == 9 {
//                AddEventSheetView(onCancelTapped: onTap)
            } else if appIcon.index == 5 || appIcon.index ==  6 || appIcon.index == 7 {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            onTap()
                        }
                    let width = appIcon.index == 7 ? 160.0 : 240.0
                    BubbleView(position: position, isPresented: $showPopup, index: appIcon.index, width: width)
                }
            } else {
                ZStack {
                    if showCover {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .onTapGesture {
                                onTap()
                                withAnimation {
                                    showPopup = false
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        showCover = false
                                    }
                                }
                            }
                    }
                    
                    PopupView(isPresented: $showPopup, appIcon: $appIcon)
                        .transition(.identity)
                        .zIndex(1)
                }
                .animation(.easeInOut, value: showCover)
            }
        }
    }
}


// MARK: - 1/3 팝업뷰
struct PopupView: View {
    @Binding var isPresented: Bool
    @State private var popupOffset: CGFloat = UIScreen.main.bounds.height
    @State private var offsetY: CGFloat = 0
    
    @Binding var appIcon: AppIcon?
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                SubPopupView(appIcon: $appIcon)
                    .frame(height: geo.size.height / 3)
                    .offset(y: popupOffset)
                    .onChange(of: isPresented) { oldValue, newValue in
                        withAnimation {
                            popupOffset = newValue ? 0 : geo.size.height
                        }
                    }
                    .onAppear {
                        withAnimation(.easeOut) {
                            popupOffset = 0
                        }
                    }
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}


struct SubPopupView: View {
    @Binding var appIcon: AppIcon?
    
    var body: some View {
        VStack(spacing: 16) {
            Text(appIcon?.name ?? "없음")
                .font(.headline)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 10)
    }
}

// MARK: - 말풍선 뷰
struct BubbleView: View {
    let position: CGPoint //앱 아이콘의 중심 -> 말풍선 네모의 중앙 하단
    @Binding var isPresented: Bool
    
    let index: Int
    let width: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            let screenSize = geometry.size
            let widgetSize = WidgetSizeProvider.size(for: .systemLarge)
            let spacing = (screenSize.width - widgetSize.width) / 2
            let iconSize = (widgetSize.width - spacing * 3) / 4
            
            ZStack {
                VStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .frame(width: width, height: 120)
                    
                    TrianglePointer()
                        .fill(Color.white)
                        .frame(width: 20, height: 15)
                        .offset(x: -(width / 2) + (iconSize / 2)) //중심에서 좌로 이동
                }
                
                SubBubbleView(isPresented: $isPresented, index: index)
            }
            .position(
                x: position.x + (width / 2),
                y: position.y - (100 / 2) - 15
            )
            
        }
    }
}

struct SubBubbleView: View {
    @Binding var isPresented: Bool
    let index: Int
    
    var body: some View {
        VStack {
            if index == 5 {
                Text("위젯의 테마색을 선택합니다")
                    .foregroundStyle(Color.textBlack)
                    .padding(.bottom)
                ColorOptionView(viewModel: WidgetSettingModel())
            } else if index == 6 {
                Text("위젯의 첫번째 요일을 선택합니다")
                    .foregroundStyle(Color.textBlack)
                    .frame(width: 235)
                    .padding(.bottom)
                    .multilineTextAlignment(.center)
                FirstDayOptionView(viewModel: WidgetSettingModel())
            } else if index == 7 {
                Text("날짜 하단에 음력을 표시합니다")
                    .foregroundStyle(Color.textBlack)
                    .frame(width: 155)
                    .padding(.bottom, 5)
                    .multilineTextAlignment(.center)
                LunarDateOptionView(viewModel: WidgetSettingModel())
            }
        }
        .font(.subheadline)
        .bold()
        .padding(.bottom)
    }
}

struct TrianglePointer: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // 왼쪽 위 -> 오른쪽 위 -> 중앙 아래
        path.move(to: CGPoint(x: rect.minX, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX, y: 0))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.closeSubpath()
        
        return path
    }
}

struct ColorOptionView: View {
    @ObservedObject var viewModel: WidgetSettingModel
    
    var body: some View {
        HStack(spacing: 18) {
            ForEach(WidgetTheme.allCases, id: \.self) { theme in
                Button(action: {
                    viewModel.themeColor = theme.name
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(theme.color)
                            .frame(width: 20, height: 20)
                        
                        if viewModel.themeColor == theme.name {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.black.opacity(0.7))
                                .font(.system(size: 13, weight: .bold))
                        }
                    }
                }
            }
        }
    }
}

struct FirstDayOptionView: View {
    @ObservedObject var viewModel: WidgetSettingModel
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<2) { index in
                Button(action: {
                    viewModel.firstDayOfWeek = index + 1
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(hex: "D9D9D9"))
                            .frame(width: 20, height: 20)
                        
                        if viewModel.firstDayOfWeek == index + 1 {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.black.opacity(0.7))
                                .font(.system(size: 13, weight: .bold))
                        }
                    }
                }
                Text(index + 1 == 1 ? "일요일" : "월요일")
                    .foregroundStyle(Color.textBlack)
            }
        }
    }
}

struct LunarDateOptionView: View {
    @ObservedObject var viewModel: WidgetSettingModel
    
    var body: some View {
        Toggle("테마 적용", isOn: $viewModel.isLunarCalendar)
            .tint(WidgetTheme.caletteDefault.color.opacity(0.7))
            .labelsHidden()
            .fixedSize()
            .scaleEffect(0.8)
    }
}

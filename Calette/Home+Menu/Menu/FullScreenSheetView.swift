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
                    DesignSystem.Colors.Overlay.dimHeavy
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
                        DesignSystem.Colors.Overlay.dim
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
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(DesignSystem.Gradient.modalBackground)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .fill(DesignSystem.Gradient.glassTint)
                .allowsHitTesting(false)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(DesignSystem.Gradient.glassBorder, lineWidth: 1)
                .allowsHitTesting(false)
        }
        .shadow(color: DesignSystem.Shadow.fab, radius: 16, x: 0, y: 8)
    }
}

// MARK: - 말풍선 통합 Shape (본체 + 꼬리)
struct BubbleShape: Shape {
    let cornerRadius: CGFloat
    let triangleWidth: CGFloat
    let triangleHeight: CGFloat
    let triangleCenterX: CGFloat // 좌측 끝에서 삼각형 중심까지의 거리

    func path(in rect: CGRect) -> Path {
        let r = cornerRadius
        let w = rect.width
        let bodyH = rect.height - triangleHeight

        let triLeft  = triangleCenterX - triangleWidth / 2
        let triRight = triangleCenterX + triangleWidth / 2
        let triTip   = CGPoint(x: triangleCenterX, y: bodyH + triangleHeight)

        var p = Path()
        // 상단 좌측 corner 이후 시작
        p.move(to: CGPoint(x: r, y: 0))
        // 상단 우측으로
        p.addLine(to: CGPoint(x: w - r, y: 0))
        p.addArc(center: CGPoint(x: w - r, y: r), radius: r,
                 startAngle: .degrees(-90), endAngle: .degrees(0), clockwise: false)
        // 우측 아래로
        p.addLine(to: CGPoint(x: w, y: bodyH - r))
        p.addArc(center: CGPoint(x: w - r, y: bodyH - r), radius: r,
                 startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        // 하단: 우→삼각형 우변→꼭짓점→삼각형 좌변→좌
        p.addLine(to: CGPoint(x: triRight, y: bodyH))
        p.addLine(to: triTip)
        p.addLine(to: CGPoint(x: triLeft, y: bodyH))
        p.addLine(to: CGPoint(x: r, y: bodyH))
        p.addArc(center: CGPoint(x: r, y: bodyH - r), radius: r,
                 startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
        // 좌측 위로
        p.addLine(to: CGPoint(x: 0, y: r))
        p.addArc(center: CGPoint(x: r, y: r), radius: r,
                 startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        p.closeSubpath()
        return p
    }
}

// MARK: - 말풍선 뷰
struct BubbleView: View {
    let position: CGPoint // 앱 아이콘의 중심 → 말풍선 네모의 중앙 하단
    @Binding var isPresented: Bool

    let index: Int
    let width: CGFloat

    private let bodyHeight: CGFloat    = 120
    private let triangleWidth: CGFloat = 20
    private let triangleHeight: CGFloat = 15

    var body: some View {
        GeometryReader { geometry in
            let widgetSize = WidgetSizeProvider.size(for: .systemLarge)
            let spacing    = (geometry.size.width - widgetSize.width) / 2
            let iconSize   = (widgetSize.width - spacing * 3) / 4
            let triCenterX = iconSize / 2        // 좌측 끝 기준 삼각형 중심 X
            let totalHeight = bodyHeight + triangleHeight

            ZStack(alignment: .top) {
                // 통합 Shape — fill
                BubbleShape(
                    cornerRadius: 16,
                    triangleWidth: triangleWidth,
                    triangleHeight: triangleHeight,
                    triangleCenterX: triCenterX
                )
                .fill(DesignSystem.Gradient.modalBackground)

                // 글래스 오버레이
                BubbleShape(
                    cornerRadius: 16,
                    triangleWidth: triangleWidth,
                    triangleHeight: triangleHeight,
                    triangleCenterX: triCenterX
                )
                .fill(DesignSystem.Gradient.glassTint)
                .allowsHitTesting(false)

                // 그라데이션 보더 (단일 외곽선)
                BubbleShape(
                    cornerRadius: 16,
                    triangleWidth: triangleWidth,
                    triangleHeight: triangleHeight,
                    triangleCenterX: triCenterX
                )
                .stroke(DesignSystem.Gradient.glassBorder, lineWidth: 1)
                .allowsHitTesting(false)

                // 콘텐츠 (본체 영역에만)
                SubBubbleView(isPresented: $isPresented, index: index)
                    .frame(width: width, height: bodyHeight)
            }
            .frame(width: width, height: totalHeight)
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
                    .foregroundStyle(DesignSystem.Colors.primary)
                    .padding(.bottom)
                ColorOptionView()
            } else if index == 6 {
                Text("위젯의 첫번째 요일을 선택합니다")
                    .foregroundStyle(DesignSystem.Colors.primary)
                    .frame(width: 235)
                    .padding(.bottom)
                    .multilineTextAlignment(.center)
                FirstDayOptionView()
            } else if index == 7 {
                Text("날짜 하단에 음력을 표시합니다")
                    .foregroundStyle(DesignSystem.Colors.primary)
                    .frame(width: 155)
                    .padding(.bottom, 5)
                    .multilineTextAlignment(.center)
                LunarDateOptionView()
            }
        }
        .font(.subheadline)
        .bold()
        .padding(.bottom)
    }
}


struct ColorOptionView: View {
    @EnvironmentObject var calendarSettingVM: CalendarSettingsViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(WidgetTheme.allCases, id: \.self) { theme in
                Button(action: {
                    calendarSettingVM.themeColor = theme.name
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(theme.color)
                            .strokeBorder(DesignSystem.Colors.border, lineWidth: 1)
                            .frame(width: 20, height: 20)
                        
                        if calendarSettingVM.currentTheme == theme {
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
    @EnvironmentObject var calendarSettingVM: CalendarSettingsViewModel
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<2) { index in
                Button(action: {
                    calendarSettingVM.firstDayOfWeek = index + 1
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(DesignSystem.Colors.border)
                            .overlay {
                                RoundedRectangle(cornerRadius: 4)
                                    .strokeBorder(DesignSystem.Colors.border, lineWidth: 1)
                            }
                            .frame(width: 20, height: 20)
                        
                        if calendarSettingVM.firstDayOfWeek == index + 1 {
                            Image(systemName: "checkmark")
                                .foregroundStyle(DesignSystem.Colors.primary)
                                .font(.system(size: 13, weight: .bold))
                        }
                    }
                }
                Text(index + 1 == 1 ? "일요일" : "월요일")
                    .foregroundStyle(DesignSystem.Colors.primary)
            }
        }
    }
}

struct LunarDateOptionView: View {
    @EnvironmentObject var calendarSettingVM: CalendarSettingsViewModel
    
    var body: some View {
        Toggle("테마 적용", isOn: $calendarSettingVM.isLunarCalendar)
            .tint(DesignSystem.Colors.accent)
            .labelsHidden()
            .fixedSize()
            .scaleEffect(0.8)
    }
}

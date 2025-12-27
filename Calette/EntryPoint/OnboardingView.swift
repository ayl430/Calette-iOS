//
//  OnboardingView.swift
//  Calette
//
//  Created by yeri on 6/29/25.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboarding: Bool
    
    @State private var currentStep: Int = 1
    var onComplete: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            let layout = HomeScreenLayout(
                screenSize: geometry.size,
                safeAreaInsets: geometry.safeAreaInsets
            )
            
            ZStack {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()                
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            if currentStep == 1 {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentStep = 2
                                }
                            } else {
                                isOnboarding = false
                                onComplete()
                            }
                        } label: {
                            Text(currentStep == 1 ? "다음 →" : "확인 →")
                                .font(.headline)
                                .foregroundStyle(Color(hex: "2E2E2E"))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.white)
                                .clipShape(Capsule())
                        }
                        .padding(.trailing, layout.iconSpacing)
                        .padding(.top)
                    }
                    Spacer()
                }
                
                if currentStep == 1 {
                    OnboardingStep1View(layout: layout)
                        .transition(.opacity)
                } else {
                    OnboardingStep2View(layout: layout)
                        .transition(.opacity)
                }
            }
        }
    }
}

// MARK: - Onboarding 1
struct OnboardingStep1View: View {
    let layout: HomeScreenLayout
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Spacer()
                Text("위젯을 추가하고\n다양한 옵션을 설정해보세요!")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(.trailing, layout.screenSize.width / 4)
            }
            .padding(.bottom, layout.iconSize * 2)
            
            HStack(spacing: layout.iconSpacing) {
                ForEach(0..<4, id: \.self) { index in
                    Color.clear
                        .frame(width: layout.iconSize, height: layout.iconSize)
                        .overlay {
                            if index < 3 {
                                DashedCircleView(size: layout.iconSize + 16)
                            }
                        }
                }
            }
            .padding(.bottom)
            .padding(.bottom, 2)
        }
    }
}

// MARK: - Onboarding 2
struct OnboardingStep2View: View {
    let layout: HomeScreenLayout
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: layout.widgetSize.height / 2 - layout.iconSize)
            
            Image(systemName: "arrow.left.arrow.right")
                .font(.system(size: 50, weight: .medium))
                .foregroundStyle(Color.white)
                .padding(.bottom, 20)
            
            Text("캘린더를 스와이프 하여\n날짜를 확인해보세요!")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(Color.white)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
    }
}

// MARK: - 점선 원
struct DashedCircleView: View {
    let size: CGFloat
    
    var body: some View {
        Circle()
            .stroke(
                Color.white,
                style: StrokeStyle(
                    lineWidth: 2,
                    dash: [6, 4]
                )
            )
            .frame(width: size, height: size)
    }
}

#Preview {
    ZStack {
        ContentView()
        OnboardingView(isOnboarding: .constant(true), onComplete: {})
    }
}

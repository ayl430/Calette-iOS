//
//  OnboardingView.swift
//  Calette
//
//  Created by yeri on 6/29/25.
//

import SwiftUI

// MARK: - 온보딩 OnboardingTabView
struct OnboardingTabView: View {
    @Binding var isOnboarding: Bool
    
    private let totalPages = 3
    @State private var selectedPage = 0
    
    var body: some View {
        ZStack {
            Image("imgBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                VStack {
                    HStack(spacing: 8) {
                        ForEach(0..<totalPages, id: \.self) { index in
                            Circle()
                                .frame(width: 6, height: 6)
                                .foregroundColor(index == selectedPage ? Color.black : Color.black.opacity(0.2))
                                .opacity(selectedPage == 3 ? 0 : 1)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.9))
                    .clipShape(Capsule())
                    
                }
                
                TabView(selection: $selectedPage) {
                    OnboardingCommonView(title: "심플한 위젯으로\n하루 일정을 확인해보세요!", imageName: "imgOnboarding1")
                        .tag(0)
                    
                    OnboardingCommonView(title: "기본 캘린더에 저장된 이벤트를\n깔끔하게 보여줍니다!", imageName: "imgOnboarding2")
                        .tag(1)
                    
                    OnboardingLastView(title: "음력도 빠르게\n확인할 수 있어요!", imageName: "imgOnboarding3", isOnboarding: $isOnboarding)
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .padding(.top, 100)
        }
    }
}

struct OnboardingCommonView: View {
    let title: String
    let imageName: String
    
    var body: some View {
        VStack() {
            Text(title)
                .multilineTextAlignment(.center)
                .font(.title3)
                .foregroundStyle(Color.textBlack)
                .bold()
                .padding()
            Image(imageName)
                .resizable()
                .scaledToFit()
                .padding(.bottom)
                .clipped()
            Spacer()
        }
    }
}

struct OnboardingLastView: View {
    let title: String
    let imageName: String
    
    @Binding var isOnboarding: Bool
    
    var body: some View {
        VStack() {
            Text(title)
                .multilineTextAlignment(.center)
                .font(.title3)
                .foregroundStyle(Color.textBlack)
                .bold()
                .padding()
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal)
            Button {
                isOnboarding.toggle()
            } label: {
                Text("앱 시작하기")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .bold()
                    .padding(.horizontal, 40)
                    .padding(.vertical, 10)
                    .background(Color(hex: "DD6464"))
                    .clipShape(Capsule())
            }
            .padding(.top)
            
            Spacer()
        }
    }
}

#Preview(body: {
    OnboardingTabView(isOnboarding: Binding.constant(false))
})

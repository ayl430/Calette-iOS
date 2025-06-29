//
//  OnboardingView.swift
//  JustCalendar
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
                .padding(.top, 80)
                
                TabView(selection: $selectedPage) {
                    OnboardingCommonView(title: "심플한 캘린더 위젯을 추가해보세요!", imageName: "imgOnboarding1")
                        .tag(0)
                    
                    OnboardingCommonView(title: "기본 캘린더에 저장된 일정을 \n표시할 수 있어요!", imageName: "imgOnboarding2")
                        .tag(1)
                    
                    OnboardingLastView(title: "음력 날짜와 함께 일정을\n확인할 수 있어요!", imageName: "imgOnboarding2", isOnboarding: $isOnboarding)
                        .tag(2)
                }
                .ignoresSafeArea()
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
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
                .bold()
                .padding()
            Image(imageName)
                .padding()
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
                .bold()
                .padding()
            Image(imageName)
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


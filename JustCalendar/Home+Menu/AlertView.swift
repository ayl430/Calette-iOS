//
//  AlertView.swift
//  JustCalendar
//
//  Created by yeri on 7/18/25.
//

import SwiftUI

struct AlertView: View {
    
    @Binding var showAlertView: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    showAlertView.toggle()
                }
            VStack(spacing: 20) {
                Text("일정 추가를 위해 캘린더앱 접근 권한이 필요합니다")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                    .padding(.horizontal)
                
                HStack {
                    Button {
                        showAlertView.toggle()
                    } label: {
                        Text("취소")
                            .foregroundStyle(Color(hex: "686868"))
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    
                    Button {
                        showAlertView.toggle()
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Text("확인")
                            .foregroundStyle(Color.justDefaultColor)
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                .frame(height: 44)
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width * 0.75)
            .background(.white)
            .cornerRadius(20)
            .shadow(radius: 10)
        }
    }
}

#Preview {
    AlertView(showAlertView: .constant(true))
}

//
//  AlertView.swift
//  Calette
//
//  Created by yeri on 7/18/25.
//

import SwiftUI

struct AlertView: View {
    let message: String
    let tapped: () -> Void
    
    @Binding var showAlertView: Bool
    
    var body: some View {
        ZStack {
            DesignSystem.Colors.Overlay.dim
                .ignoresSafeArea()
                .onTapGesture {
                    showAlertView.toggle()
                }
            VStack(spacing: 20) {
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(DesignSystem.Colors.primary)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                    .padding(.horizontal)

                HStack {
                    Button {
                        showAlertView.toggle()
                    } label: {
                        Text("취소")
                            .foregroundStyle(DesignSystem.Colors.secondary)
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()

                    Button {
                        showAlertView.toggle()
                        tapped()
                    } label: {
                        Text("확인")
                            .foregroundStyle(DesignSystem.Colors.accent)
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                .frame(height: 44)
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width * 0.75)
            .background(DesignSystem.Colors.surface)
            .cornerRadius(20)
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(DesignSystem.Colors.border, lineWidth: 1)
            }
            .shadow(radius: 10)
        }
    }
}

#Preview {
    AlertView(message: "메세지 입니다", tapped: {
        //
    }, showAlertView: .constant(true))
}

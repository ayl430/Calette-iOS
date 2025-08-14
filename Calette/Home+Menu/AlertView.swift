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
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    showAlertView.toggle()
                }
            VStack(spacing: 20) {
                Text(message)
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
                        tapped()
                    } label: {
                        Text("확인")
                            .foregroundStyle(Color.caletteDefault)
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
    AlertView(message: "메세지 입니다", tapped: {
        //
    }, showAlertView: .constant(true))
}

//
//  AddEventView.swift
//  Calette
//
//  Created by yeri on 12/13/25.
//

import SwiftUI

// MARK: - 일정 추가 뷰
struct AddEventView: View {
    let icon: AppIcon
    let size: CGFloat
    let tapped: () -> Void
    
    var body: some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.9))
                .frame(width: size * 0.8, height: size * 0.8)
                .clipShape(.circle)
                .shadow(color: Color.black.opacity(0.15),radius: 10)
                .overlay(
                    Image(icon.image)
                        .resizable()
                        .frame(width: size * 0.4, height: size * 0.4)
                )
        }
        .onTapGesture {
            tapped()
        }
    }
}

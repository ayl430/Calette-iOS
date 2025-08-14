//
//  CircleMenuView.swift
//  Calette
//
//  Created by yeri on 6/29/25.
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
                .frame(width: size * 0.7, height: size * 0.7)
                .clipShape(.circle)
                .shadow(color: Color.black.opacity(0.15),radius: 10)
                .overlay(
                    Image(icon.image)
                        .frame(width: size * 0.5, height: size * 0.5)
                )
        }
        .onTapGesture {
            tapped()
        }
    }
}

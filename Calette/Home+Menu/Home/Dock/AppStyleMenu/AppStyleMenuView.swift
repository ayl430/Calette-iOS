//
//  AppStyleMenuView.swift
//  Calette
//
//  Created by yeri on 6/29/25.
//

import SwiftUI

// MARK: - 아이콘 개별 뷰
struct AppIconView: View {
    let icon: AppIcon
    let size: CGFloat
    let tapped: () -> Void
    
    var body: some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.9))
                .frame(width: size, height: size)
                .overlay(
                    Image(icon.image)
                        .resizable()
                        .frame(width: size * 0.65, height: size * 0.65)
                )
        }
        .onTapGesture {
            tapped()
        }
    }
}

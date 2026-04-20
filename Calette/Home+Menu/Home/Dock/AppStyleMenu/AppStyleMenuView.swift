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
            ZStack {
                // 글래스 베이스
                RoundedRectangle(cornerRadius: 12)
                    .fill(DesignSystem.Colors.Glass.base)

                // 상단 하이라이트
                RoundedRectangle(cornerRadius: 12)
                    .fill(DesignSystem.Gradient.buttonHighlight)
                    .allowsHitTesting(false)

                // 아이콘 이미지
                Image(icon.image)
                    .resizable()
                    .frame(width: size * 0.6, height: size * 0.6)

                // 그라데이션 보더
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(DesignSystem.Gradient.glassBorder, lineWidth: 1)
                    .allowsHitTesting(false)
            }
            .frame(width: size, height: size)
            .shadow(color: DesignSystem.Shadow.card, radius: 6, x: 0, y: 3)
        }
        .onTapGesture {
            tapped()
        }
    }
}

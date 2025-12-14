//
//  ButtonStyles.swift
//  Calette
//
//  Created by yeri on 12/12/25.
//

import SwiftUI

// MARK: - 버튼 스타일

/// 버튼을 눌렀을 때 스케일 애니메이션 효과를 주는 스타일
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

/// 카드 버튼에 사용되는 스타일 (스케일 + 투명도 변화)
struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

//
//  WidgetTipsView.swift
//  Calette
//
//  Created by yeri on 4/30/26.
//

import SwiftUI

// MARK: - 위젯 활용 팁 페이지
struct WidgetTipsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                        Text("뒤로")
                            .font(.headline)
                    }
                    .foregroundStyle(DesignSystem.Colors.secondary)
                    .padding()
                }
                Spacer()
                Text("위젯 활용 팁")
                    .font(.headline)
                    .foregroundStyle(DesignSystem.Colors.primary)
                    .padding()
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                    Text("뒤로")
                        .font(.headline)
                }
                .foregroundStyle(.clear)
                .padding()
            }
            .padding(.horizontal, 8)
            .padding(.top, 10)

            ScrollView {
                VStack(spacing: 16) {
                    WidgetTipCard(
                        iconName: "hand.tap.fill",
                        title: "위젯 편집 활용하기",
                        description: "위젯을 길게 누르면 ‘위젯 편집’ 메뉴가 나타나요.\n테마 색상, 디자인 스타일, 첫번째 요일 등 다양한 옵션을 설정할 수 있어요."
                    )

                    WidgetTipCard(
                        iconName: "rectangle.stack.fill",
                        title: "스마트 스택 활용하기",
                        description: "작은 캘린더 위젯 두개를 '스마트 스택'에 넣어보세요.\n위 아래로 스와이프해서 이전 달과 다음 달을 빠르게 확인할 수 있어요."
                    )
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
        }
        .background(DesignSystem.Colors.background)
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - 팁 카드
struct WidgetTipCard: View {
    let iconName: String
    let title: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: iconName)
                    .font(.title3)
                    .foregroundStyle(DesignSystem.Colors.accent)
                Text(title)
                    .font(.callout)
                    .bold()
                    .foregroundStyle(DesignSystem.Colors.primary)
            }

            Text(description)
                .font(.subheadline)
                .foregroundStyle(DesignSystem.Colors.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(DesignSystem.Colors.Glass.base)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(DesignSystem.Colors.border, lineWidth: 1)
        }
    }
}

#Preview {
    WidgetTipsView()
}

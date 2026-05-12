//
//  ScopeSegmentedControl.swift
//  Calette
//
//  날짜 상세 페이지의 일/주/월 segmented control.
//  iOS 기본 segmented control 스타일을 앱 다크 테마에 맞춰 재구현.
//

import SwiftUI

struct ScopeSegmentedControl: View {
    @Binding var selection: EventListScope
    let accentColor: Color

    @Namespace private var pillNamespace

    var body: some View {
        HStack(spacing: 0) {
            ForEach(EventListScope.allCases) { scope in
                segmentButton(for: scope)
            }
        }
        .padding(4)
        .background {
            Capsule()
                .fill(
                    LinearGradient(
                        colors: [DesignSystem.Colors.Glass.tintTop, DesignSystem.Colors.Glass.tintBottom],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .allowsHitTesting(false)
        }
        .overlay {
            Capsule()
                .strokeBorder(
                    LinearGradient(
                        colors: [DesignSystem.Colors.Glass.borderTop, DesignSystem.Colors.Glass.borderBottom],
                        startPoint: .top, endPoint: .bottom
                    ),
                    lineWidth: 1
                )
                .allowsHitTesting(false)
        }
        .shadow(color: DesignSystem.Shadow.card, radius: 8, x: 0, y: 2)
        .accessibilityElement(children: .contain)
    }

    private func segmentButton(for scope: EventListScope) -> some View {
        let isSelected = selection == scope

        return Button {
            guard !isSelected else { return }
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                selection = scope
            }
        } label: {
            ZStack {
                if isSelected {
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [
                                    accentColor.opacity(0.75),
                                    accentColor.opacity(0.45)
                                ],
                                startPoint: .top, endPoint: .bottom
                            )
                        )
                        .overlay {
                            Capsule()
                                .strokeBorder(DesignSystem.Gradient.buttonBorder, lineWidth: 1)
                                .allowsHitTesting(false)
                        }
                        .shadow(color: accentColor.opacity(0.3), radius: 6, x: 0, y: 2)
                        .matchedGeometryEffect(id: "scopePill", in: pillNamespace)
                }

                Text(scope.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(isSelected ? .white : DesignSystem.Colors.secondary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 32)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(scope.title) 단위")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

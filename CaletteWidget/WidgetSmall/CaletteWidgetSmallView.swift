//
//  CaletteWidgetSmallView.swift
//  Calette
//
//  Created by yeri on 12/18/25.
//

import SwiftUI
import WidgetKit

struct CaletteWidgetSmallView: View {
    var entry: CaletteWidgetSmallProvider.Entry

    private var accentColor: Color { entry.backgroundColor.color }
    private var dateColor: Color {
        entry.isHoliday ? WidgetColor.holiday.color : WidgetColor.primaryText.color
    }

    private var calendarRing: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(accentColor.opacity(0.35))
            .overlay {
                RoundedRectangle(cornerRadius: 3)
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.90), accentColor.opacity(0.70)],
                            startPoint: .top, endPoint: .bottom
                        )
                    )
                    .allowsHitTesting(false)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 3)
                    .strokeBorder(accentColor.opacity(0.50), lineWidth: 0.5)
                    .allowsHitTesting(false)
            }
            .frame(width: 8, height: 16)
    }

    var body: some View {
        ZStack {
            // 글래스 카드 — 테마색 tint 적용
            RoundedRectangle(cornerRadius: 20)
                .fill(accentColor.opacity(0.12))
                .overlay {
                    // 상단 밝고 하단 어둡게 — accent 색 그라디언트 tint
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [accentColor.opacity(0.22), accentColor.opacity(0.04)],
                                startPoint: .top, endPoint: .bottom
                            )
                        )
                        .allowsHitTesting(false)
                }
                .overlay {
                    // 보더: 상단은 accent 색, 하단은 white 미미하게
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(
                            LinearGradient(
                                colors: [accentColor.opacity(0.60), Color.white.opacity(0.06)],
                                startPoint: .top, endPoint: .bottom
                            ),
                            lineWidth: 1
                        )
                        .allowsHitTesting(false)
                }
                .shadow(color: accentColor.opacity(0.18), radius: 8, x: 0, y: 2)
                .padding(8)

            // 캘린더 고리 — 카드 상단 위로 돌출
            VStack {
                HStack(spacing: 36) {
                    calendarRing
                    calendarRing
                }
                .offset(y: 2)
                Spacer()
            }

            VStack(spacing: 0) {
                // 날짜 숫자
                ZStack(alignment: .topTrailing) {
                    Text(entry.date.toStringD())
                        .font(.system(size: 52, weight: .bold, design: .rounded))
                        .foregroundStyle(dateColor)
                    // 이벤트 도트
                    if entry.hasEvent {
                        Circle()
                            .fill(accentColor)
                            .frame(width: 7, height: 7)
                            .shadow(color: accentColor.opacity(0.8), radius: 3, x: 0, y: 0)
                            .offset(x: 2, y: 4)
                    }
                }

                // 음력 날짜
                HStack(spacing: 4) {
                    Image(systemName: "moon.fill")
                        .font(.system(size: 9, weight: .medium))
                        .foregroundStyle(accentColor.opacity(0.75))
                    Text(entry.date.lunarDate.toStringMdd())
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(WidgetColor.secondaryText.color)
                }
                .padding(.bottom, 6)
            }
            .padding(.horizontal, 16)
        }
    }
}


#Preview {
    CaletteWidgetSmallView(entry: CaletteWidgetSmallEntry(date: Date(), backgroundColor: .dustyLavender, hasEvent: true, isHoliday: false))
}

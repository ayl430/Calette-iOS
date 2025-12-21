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

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(WidgetColor.cardBackground.color)
                .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
                .padding(10)
            VStack {
                HStack(spacing: 36) {
                    Capsule()
                        .fill(WidgetColor.ringColor.color)
                        .frame(width: 8, height: 16)
                    Capsule()
                        .fill(WidgetColor.ringColor.color)
                        .frame(width: 8, height: 16)
                }
                .offset(y: 2)
                Spacer()
            }

            VStack(spacing: 1) {
                ZStack(alignment: .topTrailing) {
                    Text(entry.date.toStringD())
                        .font(.system(size: 50, weight: .bold, design: .rounded))
                        .foregroundColor(entry.isHoliday ? Color(hex: "E57373") : WidgetColor.dayTextColor.color)

                    if entry.hasEvent {
                        Circle()
                            .fill(Color(hex: "5C8CF0"))
                            .frame(width: 8, height: 8)
                            .offset(x: 4, y: 5)
                    }
                }

                HStack(spacing: 4) {
                    Image(systemName: "moon.fill")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(WidgetColor.moonIconColor.color)
                    Text(entry.date.lunarDate.toStringMdd())
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(WidgetColor.lunarTextColor.color)
                }
            }
            .padding(.top, 6)
        }
    }
}


#Preview {
    CaletteWidgetSmallView(entry: CaletteWidgetSmallEntry(date: Date(), backgroundColor: .orange, hasEvent: true, isHoliday: true))
}

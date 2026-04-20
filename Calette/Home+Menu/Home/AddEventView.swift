//
//  AddEventView.swift
//  Calette
//
//  Created by yeri on 12/13/25.
//

import SwiftUI

struct AddEventView: View {
    @Binding var selectedApp: AppIcon?
    @Binding var selectedIndex: Int
    @Binding var showAddSheet: Bool
    @Binding var showAlertView: Bool
    
    @EnvironmentObject var dateVM: DateViewModel
    
    let layout: HomeScreenLayout
    
    private let appIcon = AppIcon(
        index: 9,
        type: AppIconType.name(for: 8),
        image: AppIconType.addEvent.image
    )
    
    var body: some View {
        HStack {
            Spacer()
            AddEventItem(icon: appIcon, size: layout.iconSize) {
                selectedApp = appIcon
                selectedIndex = 9
                
                if EventManager.shared.isFullAccess {
                    showAddSheet = true
                } else {
                    showAlertView = true
                }
            }
            .anchorPreference(key: AppIconViewPreferenceKey.self, value: .bounds) { anchor in
                [9: anchor]
            }
            .sheet(isPresented: $showAddSheet) {
                AddEvent(dateVM: dateVM)
            }
        }
    }
}

struct AddEventItem: View {
    let icon: AppIcon
    let size: CGFloat
    let tapped: () -> Void

    @EnvironmentObject var calendarSettingVM: CalendarSettingsViewModel

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(calendarSettingVM.currentTheme.buttonGradient)

                // 상단 하이라이트 빛 반사
                Circle()
                    .fill(DesignSystem.Gradient.buttonHighlight)
                    .allowsHitTesting(false)

                // 테두리: 상단 밝고 하단 어두운 그라데이션
                Circle()
                    .strokeBorder(DesignSystem.Gradient.buttonBorder, lineWidth: 1)
                    .allowsHitTesting(false)

                // + 아이콘
                Image(icon.image)
                    .resizable()
                    .frame(width: size * 0.4, height: size * 0.4)
            }
            .frame(width: size * 0.8, height: size * 0.8)
            .shadow(color: DesignSystem.Shadow.fab, radius: 8, x: 0, y: 6)
            .shadow(color: calendarSettingVM.currentTheme.glowColor, radius: 12, x: 0, y: 2)
        }
        .onTapGesture {
            tapped()
        }
    }
}

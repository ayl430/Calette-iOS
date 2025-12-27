//
//  DockView.swift
//  Calette
//
//  Created by yeri on 12/27/25.
//

import SwiftUI

struct DockView: View {
    @Binding var selectedApp: AppIcon?
    @Binding var selectedIndex: Int
    @Binding var showFaqView: Bool
    
    let layout: HomeScreenLayout
    
    var body: some View {
        HStack(spacing: layout.iconSpacing) {
            ForEach(4..<8, id: \.self) { index in
                let iconIndex = index + 1
                let appIcon = AppIcon(
                    index: iconIndex,
                    type: AppIconType.name(for: index),
                    image: AppIconType.image(for: index)
                )
                
                DockItem(
                    appIcon: appIcon,
                    size: layout.iconSize,
                    isFaqButton: iconIndex == 8
                ) {
                    selectedApp = appIcon
                    selectedIndex = iconIndex
                    if iconIndex == 8 {
                        showFaqView = true
                    }
                }
            }
        }
        .padding()
        .background(
            VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: HomeScreenLayout.dockCornerRadius))
        )
        .shadow(
            color: Color.black.opacity(HomeScreenLayout.dockShadowOpacity),
            radius: 8,
            x: 0,
            y: 4
        )
    }
}

struct DockItem: View {
    let appIcon: AppIcon
    let size: CGFloat
    let isFaqButton: Bool
    let action: () -> Void
    
    var body: some View {
        AppIconView(icon: appIcon, size: size, tapped: action)
            .anchorPreference(key: AppIconViewPreferenceKey.self, value: .bounds) { anchor in
                [appIcon.index: anchor]
            }
    }
}

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
    
    var body: some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.9))
                .frame(width: size * 0.8, height: size * 0.8)
                .clipShape(.circle)
                .shadow(color: Color.black.opacity(0.15),radius: 10)
                .overlay(
                    Image(icon.image)
                        .resizable()
                        .frame(width: size * 0.4, height: size * 0.4)
                )
        }
        .onTapGesture {
            tapped()
        }
    }
}

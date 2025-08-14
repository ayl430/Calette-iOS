//
//  MainContentView.swift
//  Calette
//
//  Created by yeri on 6/29/25.
//

import SwiftUI

// MARK: - 메인 ContentView
struct ContentView: View {
    @State private var selectedApp: AppIcon? = nil
    @State private var selectedPosition: CGPoint? = nil
    @State private var selectedIndex = 0
    
    @State private var showCover: Bool = false
    @State private var showPopup: Bool = false
    
    var body: some View {
        ZStack {
            HomeScreenWithWidget(selectedApp: $selectedApp, selectedIndex: $selectedIndex)
                .coordinateSpace(.named("container"))
                .overlayPreferenceValue(AppIconViewPreferenceKey.self) { preferences in
                    GeometryReader { geometry in
                        
                        Color.clear
                            .onChange(of: selectedIndex) { _, newValue in
                                if let anchor = preferences[newValue] {
                                    let rect = geometry[anchor]
                                    selectedPosition = CGPoint(x: rect.minX, y: rect.minY)
                                    
                                } else {
                                    selectedPosition = nil
                                }
                                showCover.toggle()
                                showPopup.toggle()
                            }
                    }
                }
            
            if let position = selectedPosition {
                AppFullScreenView(appIcon: $selectedApp, position: position, showCover: $showCover, showPopup: $showPopup) {
                    selectedApp = nil
                    selectedPosition = nil
                    selectedIndex = 0
                }
            }
        }
    }
}

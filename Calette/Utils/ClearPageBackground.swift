//
//  ClearPageBackground.swift
//  Calette
//

import SwiftUI

struct ClearPageBackground: UIViewRepresentable {
    func makeUIView(context: Context) -> BackgroundClearerView {
        BackgroundClearerView()
    }
    func updateUIView(_ uiView: BackgroundClearerView, context: Context) {}
}

class BackgroundClearerView: UIView {
    override func didMoveToWindow() {
        super.didMoveToWindow()
        clearPageViewBackgrounds()
    }

    private func clearPageViewBackgrounds() {
        var current: UIView? = self
        while let view = current {
            if NSStringFromClass(type(of: view)).contains("Page") {
                view.backgroundColor = .clear
            }
            current = view.superview
        }
    }
}

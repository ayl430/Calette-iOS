//
//  VisualEffectBlur.swift
//  Calette
//
//  Created by yeri on 6/29/25.
//

import SwiftUI

struct VisualEffectBlur: UIViewRepresentable {
    let blurStyle: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

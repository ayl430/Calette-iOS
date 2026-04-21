//
//  WidgetBackgroundColor.swift
//  Calette
//
//  Created by yeri on 12/18/25.
//

import AppIntents
import SwiftUI

enum WidgetBackgroundColor: String, AppEnum {
    case dustyLavender
    case softPeach
    case mintGreen
    case mutedCoral
    case slateSilver
    case iceCyan

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "테마 색상"
    }

    static var caseDisplayRepresentations: [WidgetBackgroundColor: DisplayRepresentation] {
        [
            .dustyLavender: DisplayRepresentation(title: "💜 Dusty Lavender"),
            .softPeach:     DisplayRepresentation(title: "🍑 Soft Peach"),
            .mintGreen:     DisplayRepresentation(title: "🌿 Mint Green"),
            .mutedCoral:    DisplayRepresentation(title: "🪸 Muted Coral"),
            .slateSilver:   DisplayRepresentation(title: "🪙 Slate Silver"),
            .iceCyan:       DisplayRepresentation(title: "💎 Ice Cyan")
        ]
    }

    var color: Color {
        switch self {
        case .dustyLavender: return DesignSystem.Colors.Theme.dustyLavender
        case .softPeach:     return DesignSystem.Colors.Theme.softPeach
        case .mintGreen:     return DesignSystem.Colors.Theme.mintGreen
        case .mutedCoral:    return DesignSystem.Colors.Theme.mutedCoral
        case .slateSilver:   return DesignSystem.Colors.Theme.slateSilver
        case .iceCyan:       return DesignSystem.Colors.Theme.iceCyan
        }
    }
}

enum WidgetColor {
    case primaryText
    case secondaryText
    case holiday

    var color: Color {
        switch self {
        case .primaryText:   return Color(hex: "F0EDF8")
        case .secondaryText: return Color(hex: "9E9BAE")
        case .holiday:       return Color(hex: "FF6370")
        }
    }
}

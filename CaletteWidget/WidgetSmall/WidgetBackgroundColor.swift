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
        (WidgetTheme(rawValue: rawValue) ?? .dustyLavender).color
    }
}

enum WidgetColor {
    case primaryText
    case secondaryText
    case holiday

    var color: Color {
        switch self {
        case .primaryText:   return DesignSystem.Colors.Widget.primaryText
        case .secondaryText: return DesignSystem.Colors.Widget.secondaryText
        case .holiday:       return DesignSystem.Colors.Widget.holiday
        }
    }
}

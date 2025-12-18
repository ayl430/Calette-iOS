//
//  WidgetBackgroundColor.swift
//  Calette
//
//  Created by yeri on 12/18/25.
//

import AppIntents
import SwiftUI

enum WidgetBackgroundColor: String, AppEnum {
    case orange = "F5C28A"
    case pink = "F5A8B8"
    case yellow = "F5E6A3"
    case green = "A8D5BA"
    case blue = "A8C5F5"
    case purple = "D4A8F5"
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "배경 색상"
    }
    
    static var caseDisplayRepresentations: [WidgetBackgroundColor: DisplayRepresentation] {
        [
            .orange: DisplayRepresentation(title: "🟠 Orange"),
            .pink: DisplayRepresentation(title: "🩷 Pink"),
            .yellow: DisplayRepresentation(title: "🌕 Yellow"),
            .green: DisplayRepresentation(title: "🍏 Green"),
            .blue: DisplayRepresentation(title: "🐳 Blue"),
            .purple: DisplayRepresentation(title: "🍇 Purple")
        ]
    }
    
    var darkColor: Color {
        switch self {
        case .orange: return Color(hex: "3D2E1F")
        case .pink: return Color(hex: "3D2832")
        case .yellow: return Color(hex: "3D3820")
        case .green: return Color(hex: "243D2E")
        case .blue: return Color(hex: "242E3D")
        case .purple: return Color(hex: "32243D")
        }
    }
    
    var color: Color {
        Color(hex: self.rawValue).dark(self.darkColor)
    }
}

enum WidgetColor: String {
    case cardBackground = "FDF6E8"
    case ringColor = "9A9A9E"
    case dayTextColor = "1C1C1E"
    case holidayTextColor = "E57373"
    case lunarTextColor = "6C6C70"
    case moonIconColor = "AEAEB2"
    
    var darkColor: Color {
        switch self {
        case .cardBackground: return Color(hex: "2C2C2E")
        case .ringColor: return Color(hex: "636366")
        case .dayTextColor: return Color(hex: "F5F5F7")
        case .holidayTextColor: return Color(hex: "E57373")
        case .lunarTextColor: return Color(hex: "A1A1A6")
        case .moonIconColor: return Color(hex: "8E8E93")
        }
    }
    
    var color: Color {
        Color(hex: self.rawValue).dark(self.darkColor)
    }
}

//
//  ColorExtension.swift
//  Calette
//
//  Created by yeri on 12/12/25.
//

import SwiftUI

extension Color {
    init(hex: String, alpha: Double = 1.0) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b, opacity: alpha)
    }
    
    init(name: String, alpha: Double = 1.0) {
        let resolved = WidgetTheme(rawValue: name) ?? .dustyLavender
        self = resolved.color.opacity(alpha)
    }
    
    // 테마색
    static let caletteDefault = Color(hex: "FF6F4A")
    static let caletteYellow = Color(hex: "FFAA28")
    static let calettePink = Color(hex: "FF7088")
    static let calettePurple = Color(hex: "9F6BE8")
    static let caletteBlue = Color(hex: "6A8FE8")
    
    // 텍스트, 배경 색
    static let textBlack = Color(hex: "0C0C0C") // 2C2C2C
    static let selectedDateBG = Color(hex: "F3F3F3") // 413C38(다크모드)
    static let lunarDate = Color(hex: "9C9892") // A89E94(다크모드)

    // 다크모드 지원
    func dark(_ darkColor: Color) -> Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(darkColor)
            : UIColor(self)
        })
    }
}



enum WidgetTheme: String, CaseIterable {
    case dustyLavender
    case softPeach
    case mintGreen
    case mutedCoral
    case deepPurple
    case midnightBase

    /// 옛 이름(caletteDefault 등) → 새 이름 마이그레이션 포함
    init?(rawValue: String) {
        switch rawValue {
        // 새 이름
        case "dustyLavender":  self = .dustyLavender
        case "softPeach":      self = .softPeach
        case "mintGreen":      self = .mintGreen
        case "mutedCoral":     self = .mutedCoral
        case "deepPurple":     self = .deepPurple
        case "midnightBase":   self = .midnightBase
        // 옛 이름 → 새 이름 매핑
        case "caletteDefault": self = .dustyLavender
        case "caletteYellow":  self = .softPeach
        case "calettePink":    self = .mutedCoral
        case "calettePurple":  self = .deepPurple
        case "caletteBlue":    self = .mintGreen
        default:               self = .dustyLavender
        }
    }

    var name: String { self.rawValue }

    var color: Color {
        switch self {
        case .dustyLavender: return DesignSystem.Colors.Theme.dustyLavender
        case .softPeach:     return DesignSystem.Colors.Theme.softPeach
        case .mintGreen:     return DesignSystem.Colors.Theme.mintGreen
        case .mutedCoral:    return DesignSystem.Colors.Theme.mutedCoral
        case .deepPurple:    return DesignSystem.Colors.Theme.deepPurple
        case .midnightBase:  return DesignSystem.Colors.Theme.midnightBase
        }
    }

    /// 테마별 버튼 그라데이션
    var buttonGradient: LinearGradient {
        LinearGradient(
            colors: [color.opacity(0.7), color.opacity(0.4)],
            startPoint: .top, endPoint: .bottom
        )
    }

    /// 테마별 글로우 쉐도우 색
    var glowColor: Color {
        color.opacity(0.35)
    }
}

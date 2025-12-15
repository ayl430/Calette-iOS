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
        switch name {
        case "caletteDefault":
            self = .caletteDefault.opacity(alpha)
        case "caletteYellow":
            self = .caletteYellow.opacity(alpha)
        case "calettePink":
            self = .calettePink.opacity(alpha)
        case "calettePurple":
            self = .calettePurple.opacity(alpha)
        case "caletteBlue":
            self = .caletteBlue.opacity(alpha)
        default:
            self = .caletteDefault.opacity(alpha)
        }
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
    case caletteDefault
    case caletteYellow
    case calettePink
    case calettePurple
    case caletteBlue
    
    init?(rawValue: String) {
        switch rawValue {
        case "caletteDefault":
            self = .caletteDefault
        case "caletteYellow":
            self = .caletteYellow
        case "calettePink":
            self = .calettePink
        case "calettePurple":
            self = .calettePurple
        case "caletteBlue":
            self = .caletteBlue
        default:
            self = .caletteDefault
        }
    }
    
    var name: String {
        self.rawValue
    }
    
    var color: Color {
        switch self {
        case .caletteDefault:
            return Color(hex: "FF6F4A")
        case .caletteYellow:
            return Color(hex: "FFAA28")
        case .calettePink:
            return Color(hex: "FF7088")
        case .calettePurple:
            return Color(hex: "9F6BE8")
        case .caletteBlue:
            return Color(hex: "6A8FE8")
        }
    }
}

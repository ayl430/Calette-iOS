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
    static let caletteDefault = Color(hex: "F7931D")
    static let caletteYellow = Color(hex: "FFBE0C")
//    static let caletteOrange = Color(hex: "FB5607")
    static let calettePink = Color(hex: "FF006E")
    static let calettePurple = Color(hex: "8338EC")
    static let caletteBlue = Color(hex: "3986FF")
    
    // 텍스트, 배경 색
    static let selectedDateBG = Color(hex: "E1E2E1")
    static let lunarDate = Color(hex: "7A7A7A")
}



enum WidgetTheme: String, CaseIterable {
    case caletteDefault
    case caletteYellow
//    case caletteOrange
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
            return Color(hex: "F7931D")
        case .caletteYellow:
            return Color(hex: "FFBE0C")
//        case .CaletteOrange:
//            return Color(hex: "FB5607")
        case .calettePink:
            return Color(hex: "FF006E")
        case .calettePurple:
            return Color(hex: "8338EC")
        case .caletteBlue:
            return Color(hex: "3986FF")
        }
    }
}

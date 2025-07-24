//
//  UIColorExtension.swift
//  JustCalendar
//
//  Created by yeri on 2/10/25.
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
        case "justDefaultColor":
            self = .justDefaultColor.opacity(alpha)
        case "justYellow":
            self = .justYellow.opacity(alpha)
        case "justPink":
            self = .justPink.opacity(alpha)
        case "justPurple":
            self = .justPurple.opacity(alpha)
        case "justBlue":
            self = .justBlue.opacity(alpha)
        default:
            self = .justDefaultColor.opacity(alpha)
        }
    }
    
    // 테마색
    static let justDefaultColor = Color(hex: "F7931D")
    static let justYellow = Color(hex: "FFBE0C")
//    static let justOrange = Color(hex: "FB5607")
    static let justPink = Color(hex: "FF006E")
    static let justPurple = Color(hex: "8338EC")
    static let justBlue = Color(hex: "3986FF")
    
    // 텍스트, 배경 색
    static let selectedDateBG = Color(hex: "E1E2E1")
    static let lunarDate = Color(hex: "7A7A7A")
}



enum WidgetTheme: String, CaseIterable {
    case justDefaultColor
    case justYellow
//    case orange
    case justPink
    case justPurple
    case justBlue
    
    init?(rawValue: String) {
        switch rawValue {
        case "justDefaultColor":
            self = .justDefaultColor
        case "justYellow":
            self = .justYellow
        case "justPink":
            self = .justPink
        case "justPurple":
            self = .justPurple
        case "justBlue":
            self = .justBlue
        default:
            self = .justDefaultColor
        }
    }
    var name: String {
        self.rawValue
    }
    
    var color: Color {
        switch self {
        case .justDefaultColor:
            return Color(hex: "F7931D")
        case .justYellow:
            return Color(hex: "FFBE0C")
//        case .orange:
//            return Color(hex: "FB5607")
        case .justPink:
            return Color(hex: "FF006E")
        case .justPurple:
            return Color(hex: "8338EC")
        case .justBlue:
            return Color(hex: "3986FF")
        }
    }
}

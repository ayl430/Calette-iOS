//
//  AppStyleMenu.swift
//  Calette
//
//  Created by yeri on 6/29/25.
//

import Foundation

// MARK: - 아이콘 정보
struct AppIcon: Identifiable {
    let id = UUID()
    let index: Int
    var name: String {
        "App \(index)"
    }
    let type: String
    let image: String
}

enum AppIconType: CaseIterable {
    case type1
    case type2
    case type3
    case type4
    
    case theme
    case FirstDay
    case lunarDay
    case faq
    
    case addEvent
    
    var name: String {
        switch self {
        case .type1:
            return "type1"
        case .type2:
            return "type2"
        case .type3:
            return "type3"
        case .type4:
            return "type4"
            
        case .theme:
            return "테마색"
        case .FirstDay:
            return "첫번째 요일"
        case .lunarDay:
            return "음력"
        case .faq:
            return "FAQ"
            
        case .addEvent:
            return "일정 추가"
        }
    }
    
    var image: String {
        switch self {
        case .type1, .type2, .type3, .type4:
            return "imgNothing"
            
        case .theme:
            return "imgDockIcon1"
        case .FirstDay:
            return "imgDockIcon2"
        case .lunarDay:
            return "imgDockIcon3"
        case .faq:
            return "imgDockIcon4"
            
        case .addEvent:
            return "imgButtonPlus"
        }
    }
    
    static func name(for index: Int) -> String {
        guard index >= 0 && index < AppIconType.allCases.count else {
            return ""
        }
        return AppIconType.allCases[index].name
    }
    
    static func image(for index: Int) -> String {
        guard index >= 0 && index < AppIconType.allCases.count else {
            return ""
        }
        return AppIconType.allCases[index].image
    }
}

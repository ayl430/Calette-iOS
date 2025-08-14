//
//  AppStyleMenuLayout.swift
//  Calette
//
//  Created by yeri on 6/29/25.
//

import Foundation

// MARK: - 아이콘 그리드 정보
struct IconGridInfo {
    let columns: Int
    let rows: Int
    let totalIcons: Int
    let dockCount: Int = 4
    var totalWithDock: Int { totalIcons + dockCount }
}

// MARK: - 아이콘 그리드 레이아웃 계산기
struct IconLayoutCalculator {
    static func calculateIconGrid(screenSize: CGSize, spacing: CGFloat = 16, widgetHeight: CGFloat = 160, maxColumns: Int = 4, dockHeight: CGFloat = 120) -> IconGridInfo {
        // 가로당 최대 아이콘
        var columns = maxColumns
        
        // 아이콘 최소 사이즈 (60-80)
        let minIconWidth: CGFloat = 70.0
        
        // 아이콘 수
        while columns > 1 {
            let totalSpacing = spacing * CGFloat(columns + 1)
            let iconWidth = (screenSize.width - totalSpacing) / CGFloat(columns)
            if iconWidth >= minIconWidth {
                break
            }
            columns -= 1
        }
        
        let iconWidth = (screenSize.width - spacing * CGFloat(columns + 1)) / CGFloat(columns)
        let usableHeight = screenSize.height - widgetHeight - dockHeight - spacing * 4
        let rowHeight = iconWidth + spacing
        let rows = Int(usableHeight / rowHeight)
        
        let totalIcons = rows * columns
        return IconGridInfo(columns: columns, rows: rows, totalIcons: totalIcons)
    }
}

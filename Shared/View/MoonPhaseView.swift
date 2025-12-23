//
//  MoonPhaseView.swift
//  Calette
//
//  Created by yeri on 12/22/25.
//

import SwiftUI

struct MoonPhaseView: View {
    let lunarDay: Int
    
    var body: some View {
        Image(moonImage(for: lunarDay))
            .resizable()
    }
    
    func moonImage(for day: Int) -> String {
        switch day {
        case 1...3, 28...30:
            return "imgMoon0"
        case 4...7:
            return "imgMoon1"
        case 8...10:
            return "imgMoon2"
        case 11...14:
            return "imgMoon3"
        case 15:
            return "imgMoon4"
        case 16...19:
            return "imgMoon5"
        case 20...22:
            return "imgMoon6"
        case 23...27:
            return "imgMoon7"
        default:
            return "imgMoon0"
        }
    }
}

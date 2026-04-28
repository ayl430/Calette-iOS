//
//  MoonPhaseView.swift
//  Calette
//
//  Created by yeri on 12/22/25.
//

import SwiftUI

struct MoonPhaseView: View {
    let lunarDay: Int
    var isClassic: Bool = false

    var body: some View {
        Image(moonImage(for: lunarDay))
            .resizable()
    }

    func moonImage(for day: Int) -> String {
        let prefix = isClassic ? "imgMoonClassic" : "imgMoon"
        switch day {
        case 1...3, 28...30:
            return "\(prefix)0"
        case 4...7:
            return "\(prefix)1"
        case 8...10:
            return "\(prefix)2"
        case 11...14:
            return "\(prefix)3"
        case 15:
            return "\(prefix)4"
        case 16...19:
            return "\(prefix)5"
        case 20...22:
            return "\(prefix)6"
        case 23...27:
            return "\(prefix)7"
        default:
            return "\(prefix)0"
        }
    }
}

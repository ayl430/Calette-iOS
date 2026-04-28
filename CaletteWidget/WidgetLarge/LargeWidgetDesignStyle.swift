//
//  LargeWidgetDesignStyle.swift
//  Calette
//
//  Created by yeri on 4/28/26.
//

import AppIntents
import SwiftUI

enum LargeWidgetDesignStyle: String, AppEnum {
    case cosmic
    case classic

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "디자인 스타일"
    }

    static var caseDisplayRepresentations: [LargeWidgetDesignStyle: DisplayRepresentation] {
        [
            .cosmic:  DisplayRepresentation(title: "👾 Cosmic"),
            .classic: DisplayRepresentation(title: "💫 Classic")
        ]
    }
}

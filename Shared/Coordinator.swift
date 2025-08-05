//
//  Coordinator.swift
//  JustCalendar
//
//  Created by yeri on 7/30/25.
//

import SwiftUI

enum NavigationStackType {
    case HomeView
    case EventDetailView
    
//    case EventEditView
}

final class Coordinator: ObservableObject {
    @Published var path: [NavigationStackType] = []
    
    func push(_ type: NavigationStackType) {
        path.append(type)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeAll()
    }
}

//
//  AddEventView.swift
//  JustCalendar
//
//  Created by yeri on 6/29/25.
//

import SwiftUI
import EventKit
import EventKitUI

// MARK: - 일정 추가 sheet 뷰
struct AddEvent: UIViewControllerRepresentable {
    typealias UIViewControllerType = EKEventEditViewController
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> EKEventEditViewController {
        let eventManager = EventManager.shared
        guard eventManager.isFullAccess else { return EKEventEditViewController() }
        
        let eventStore = eventManager.eventStore
        let controller = EKEventEditViewController()
        controller.eventStore = eventStore
        controller.editViewDelegate = context.coordinator
        
        let event = EKEvent(eventStore: eventStore)
        event.startDate = DateModel.shared.selectedDate
        event.endDate = DateModel.shared.selectedDate.addingTimeInterval(60 * 60)
        controller.event = event
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {
        
    }
    
    class Coordinator: NSObject, EKEventEditViewDelegate {
        var parent: AddEvent
        
        init(_ parent: AddEvent) {
            self.parent = parent
        }
        
        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            controller.dismiss(animated: true)
            DateModel.shared.setEvent()
        }
    }
}

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
        let eventStore = EKEventStore()
        let controller = EKEventEditViewController()
        controller.eventStore = eventStore
        controller.editViewDelegate = context.coordinator

        // Create empty event (optional)
        let event = EKEvent(eventStore: eventStore)
        event.title = "새 일정"
        controller.event = event

        // 권한 확인 및 요청
        eventStore.requestAccess(to: .event) { granted, error in
            if !granted {
                print("Calendar access denied.")
            }
        }

        return controller
    }

    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {
        // 업데이트 불필요
    }

    class Coordinator: NSObject, EKEventEditViewDelegate {
        var parent: AddEvent

        init(_ parent: AddEvent) {
            self.parent = parent
        }

        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            controller.dismiss(animated: true)
        }
    }
}

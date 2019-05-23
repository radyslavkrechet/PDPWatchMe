//
//  ExtensionDelegate.swift
//  WatchMe WatchKit App Extension
//
//  Created by Radyslav Krechet on 5/18/19.
//  Copyright © 2019 RubyGarage. All rights reserved.
//

import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {
    private var session: WCSession!
    
    // MARK: - WKExtensionDelegate

    func applicationDidFinishLaunching() {
        if WCSession.isSupported() {
            session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func applicationDidBecomeActive() {
        syncData()
    }

    // MARK: - WCSessionDelegate

    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {}

    // MARK: - Session Helpers

    func doneActivity(forHabitWithId id: UUID) {
        sendAction("done", data: id.uuidString)
    }

    func undoActivity(forHabitWithId id: UUID) {
        sendAction("undo", data: id.uuidString)
    }

    private func sendAction(_ action: String, data: Any) {
        let userInfo = ["action": action, "data": data]
        self.session.transferUserInfo(userInfo)
    }

    private func syncData() {
        let requestMessage = ["action": "sync"]
        self.session.sendMessage(requestMessage, replyHandler: { responseMessage in
            guard let data = responseMessage["data"] as? [String: Data],
                let habits = data["habits"],
                let activities = data["activities"] else {

                    return
            }

            let todayHabits = try! JSONDecoder().decode([Habit].self, from: habits)
            HabitService.setHabits(todayHabits)

            let todayActivities = try! JSONDecoder().decode([Activity].self, from: activities)
            ActivityService.setActivities(todayActivities)

            if let controller = WKExtension.shared().visibleInterfaceController as? PreparationController {
                controller.prepareController()
            }
        })
    }
}

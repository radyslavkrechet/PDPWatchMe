//
//  AppDelegate.swift
//  WatchMe
//
//  Created by Radyslav Krechet on 5/18/19.
//  Copyright © 2019 RubyGarage. All rights reserved.
//

import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {
    var window: UIWindow?

    private var session: WCSession!

    // MARK: - UIApplicationDelegate

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        ActivityService.prepareActivities()
        
        if WCSession.isSupported() {
            session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        return true
    }

    // MARK: - WCSessionDelegate

    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {}

    func sessionDidBecomeInactive(_ session: WCSession) {}

    func sessionDidDeactivate(_ session: WCSession) {}

    func session(_ session: WCSession, didReceiveMessage message: [String : Any],
                 replyHandler: @escaping ([String : Any]) -> Void) {

        if let action = message["action"] as? String, action == "sync" {
            let habits = try! JSONEncoder().encode(HabitService.todayHabits)
            let activities = try! JSONEncoder().encode(ActivityService.todayActivities)
            let data = ["habits": habits, "activities": activities]
            let responseMessage = ["data": data]
            replyHandler(responseMessage)
        }
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        guard let action = userInfo["action"] as? String else {
            return
        }

        if action == "done", let id = userInfo["data"] as? String, let habitId = UUID(uuidString: id) {
            ActivityService.doneActivity(forHabitWithId: habitId)
        }

        if action == "undo", let id = userInfo["data"] as? String, let habitId = UUID(uuidString: id) {
            ActivityService.undoActivity(forHabitWithId: habitId)
        }

        DispatchQueue.main.async {
            if let navigationContoller = self.window?.rootViewController as? UINavigationController,
                let controller = navigationContoller.visibleViewController as? PreparationController {

                controller.prepareController()
            }
        }
    }
}

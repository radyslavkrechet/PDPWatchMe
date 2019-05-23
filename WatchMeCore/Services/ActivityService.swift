//
//  ActivityService.swift
//  WatchMe
//
//  Created by Radyslav Krechet on 5/21/19.
//  Copyright © 2019 RubyGarage. All rights reserved.
//

import Foundation

private let activitiesKey = "activities"
private let activitiesDateKey = "activitiesDate"

public struct ActivityService {
    public static var todayActivities: [Activity] {
        guard let data = Storage.defaults.data(forKey: activitiesKey) else {
            return []
        }

        return try! JSONDecoder().decode([Activity].self, from: data)
    }

    public static func prepareActivities() {
        let timestamp = Storage.defaults.double(forKey: activitiesDateKey)
        let date = Date(timeIntervalSince1970: timestamp)
        if !Calendar.current.isDateInToday(date) {
            let today = Date().timeIntervalSince1970
            Storage.defaults.set(today, forKey: activitiesDateKey)

            let activities = HabitService.todayHabits.map { Activity(habitId: $0.id) }
            setActivities(activities)
        }
    }

    public static func setActivities(_ activities: [Activity]) {
        let data = try! JSONEncoder().encode(activities)
        Storage.defaults.set(data, forKey: activitiesKey)
    }

    public static func addActivity(forHabitWithId id: UUID) {
        let activity = Activity(habitId: id)
        var activities = todayActivities
        activities.insert(activity, at: 0)
        setActivities(activities)
    }

    public static func deleteActivity(forHabitWithId id: UUID) {
        var activities = todayActivities
        activities.removeAll { $0.habitId == id }
        setActivities(activities)
    }

    public static func doneActivity(forHabitWithId id: UUID) {
        replaceActivity(forHabitWithId: id, doneDelta: 1)
    }

    public static func undoActivity(forHabitWithId id: UUID) {
        replaceActivity(forHabitWithId: id, doneDelta: -1)
    }

    private static func replaceActivity(forHabitWithId id: UUID, doneDelta: Int) {
        var activities = todayActivities
        guard let index = activities.firstIndex(where: { $0.habitId == id }) else {
            return
        }

        let removedActivity = activities.remove(at: index)
        let activity = Activity(habitId: id, done: removedActivity.done + doneDelta)
        activities.insert(activity, at: index)
        setActivities(activities)
    }
}

//
//  GoalService.swift
//  WatchMe
//
//  Created by Radyslav Krechet on 5/21/19.
//  Copyright © 2019 RubyGarage. All rights reserved.
//

import Foundation

private let goalsKey = "goals"
private let goaslDateKey = "goaslDate"

struct GoalService {
    static var allGoals: [Goal] {
        guard let data = Storage.defaults.data(forKey: goalsKey) else {
            return []
        }

        return try! JSONDecoder().decode([Goal].self, from: data)
    }

    static func prepareGoals() {
        let timestamp = Storage.defaults.double(forKey: goaslDateKey)
        let goalDate = Date(timeIntervalSince1970: timestamp)
        if !Calendar.current.isDateInToday(goalDate) {
            let today = Date().timeIntervalSince1970
            Storage.defaults.set(today, forKey: goaslDateKey)

            let goals = HabitService.todayHabits.map { Goal(habitId: $0.id) }
            let data = try! JSONEncoder().encode(goals)
            Storage.defaults.set(data, forKey: goalsKey)
        }
    }

    static func addGoal(forHabitWithId id: UUID) {
        let goal = Goal(habitId: id)
        var goals = allGoals
        goals.insert(goal, at: 0)

        setGoals(goals)
    }

    static func deleteGoal(forHabitWithId id: UUID) {
        var goals = allGoals
        goals.removeAll { $0.habitId == id }

        setGoals(goals)
    }

    static func doneGoal(forHabitWithId id: UUID) {
        replaceGoal(forHabitWithId: id, doneDelta: 1)
    }

    static func undoGoal(forHabitWithId id: UUID) {
        replaceGoal(forHabitWithId: id, doneDelta: -1)
    }

    private static func setGoals(_ goals: [Goal]) {
        let data = try! JSONEncoder().encode(goals)
        Storage.defaults.set(data, forKey: goalsKey)
    }

    private static func replaceGoal(forHabitWithId id: UUID, doneDelta: Int) {
        var goals = allGoals
        guard let index = goals.firstIndex(where: { $0.habitId == id }) else {
            return
        }

        let removedGoal = goals.remove(at: index)
        let goal = Goal(habitId: id, done: removedGoal.done + doneDelta)
        goals.insert(goal, at: index)
        setGoals(goals)
    }
}

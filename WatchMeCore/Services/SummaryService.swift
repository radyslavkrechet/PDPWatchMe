//
//  SummaryService.swift
//  WatchMe
//
//  Created by Radyslav Krechet on 5/21/19.
//  Copyright © 2019 RubyGarage. All rights reserved.
//

import Foundation

public struct SummaryService {
    public static var todaySummary: Summary {
        let habits = HabitService.todayHabits
        if habits.isEmpty {
            return Summary()
        }

        let activities = ActivityService.todayActivities
        let goal = habits.reduce(0) { $0 + $1.goal }
        let done = activities.reduce(0) { $0 + $1.done }
        let completionRate = rate(withGoal: goal, done: done)

        var completed = 0
        var started = 0
        var notDone = 0
        for index in 0..<habits.count {
            let habit = habits[index]
            let goal = activities[index]
            if habit.goal == goal.done {
                completed += 1
            } else if goal.done == 0 {
                notDone += 1
            } else {
                started += 1
            }
        }

        return Summary(completionRate: completionRate, completed: completed, started: started, notDone: notDone)
    }

    public static func rate(withGoal goal: Int, done: Int) -> Int {
        return (Int(Double(100) / Double(goal) * Double(done)))
    }
}

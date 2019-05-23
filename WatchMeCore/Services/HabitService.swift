//
//  HabitService.swift
//  WatchMe
//
//  Created by Radyslav Krechet on 5/21/19.
//  Copyright © 2019 RubyGarage. All rights reserved.
//

import Foundation

private let habitsKey = "habits"

public struct HabitService {
    public static var allHabits: [Habit] {
        guard let data = Storage.defaults.data(forKey: habitsKey) else {
            return []
        }

        return try! JSONDecoder().decode([Habit].self, from: data)
    }

    public static var todayHabits: [Habit] {
        return allHabits.filter { $0.weekdays[currentWeekday] == .select }
    }

    private static var currentWeekday: Int {
        let today = Date()

        // returns an integer from 1 - 7, with 1 being Sunday and 7 being Saturday
        var weekday = Calendar.current.component(.weekday, from: today)
        if weekday == 1 {
            weekday = 8
        }
        weekday -= 2
        // now we have an integer from 0 - 6, with 0 being Monday and 6 being Sunday

        return weekday
    }

    public static func setHabits(_ habits: [Habit]) {
        let data = try! JSONEncoder().encode(habits)
        Storage.defaults.set(data, forKey: habitsKey)
    }

    public static func addHabit(withName name: String, goal: Int, weekdays: [WeekdayState]) {
        let id = UUID()
        let habit = Habit(id: id, name: name, goal: goal, weekdays: weekdays)
        var habits = allHabits
        habits.insert(habit, at: 0)
        setHabits(habits)

        if weekdays[currentWeekday] == .select {
            ActivityService.addActivity(forHabitWithId: id)
        }
    }

    public static func deleleHabit(atIndex index: Int) {
        var habits = allHabits
        let removedHabit = habits.remove(at: index)
        setHabits(habits)

        if removedHabit.weekdays[currentWeekday] == .select {
            ActivityService.deleteActivity(forHabitWithId: removedHabit.id)
        }
    }
}

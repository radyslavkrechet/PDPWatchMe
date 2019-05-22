//
//  Habit.swift
//  WatchMe
//
//  Created by Radyslav Krechet on 5/21/19.
//  Copyright © 2019 RubyGarage. All rights reserved.
//

import Foundation

struct Habit: Codable {
    let id: UUID
    let name: String
    let goal: Int
    let weekdays: [WeekdayState]

    init(id: UUID = UUID(), name: String, goal: Int, weekdays: [WeekdayState]) {
        self.id = id
        self.name = name
        self.goal = goal
        self.weekdays = weekdays
    }
}

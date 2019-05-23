//
//  Habit.swift
//  WatchMe
//
//  Created by Radyslav Krechet on 5/21/19.
//  Copyright © 2019 RubyGarage. All rights reserved.
//

import Foundation

public struct Habit: Codable {
    public let id: UUID
    public let name: String
    public let goal: Int
    public let weekdays: [WeekdayState]
}

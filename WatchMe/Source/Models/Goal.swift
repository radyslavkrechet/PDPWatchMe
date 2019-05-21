//
//  Goal.swift
//  WatchMe
//
//  Created by Radyslav Krechet on 5/21/19.
//  Copyright © 2019 RubyGarage. All rights reserved.
//

import Foundation

struct Goal: Codable {
    let habitId: UUID
    let done: Int

    init(habitId: UUID, done: Int = 0) {
        self.habitId = habitId
        self.done = done
    }
}

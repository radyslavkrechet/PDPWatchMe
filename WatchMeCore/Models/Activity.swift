//
//  Activity.swift
//  WatchMe
//
//  Created by Radyslav Krechet on 5/21/19.
//  Copyright © 2019 RubyGarage. All rights reserved.
//

import Foundation

public struct Activity: Codable {
    public let habitId: UUID
    public let done: Int

    init(habitId: UUID, done: Int = 0) {
        self.habitId = habitId
        self.done = done
    }
}

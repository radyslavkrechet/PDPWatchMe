//
//  Summary.swift
//  WatchMe
//
//  Created by Radyslav Krechet on 5/21/19.
//  Copyright © 2019 RubyGarage. All rights reserved.
//

import Foundation

public struct Summary {
    public let completionRate: Int
    public let completed: Int
    public let started: Int
    public let notDone: Int

    init(completionRate: Int = 100, completed: Int = 0, started: Int = 0, notDone: Int = 0) {
        self.completionRate = completionRate
        self.completed = completed
        self.started = started
        self.notDone = notDone
    }
}

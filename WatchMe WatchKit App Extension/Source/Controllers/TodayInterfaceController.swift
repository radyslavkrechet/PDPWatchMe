//
//  TodayInterfaceController.swift
//  WatchMe WatchKit App Extension
//
//  Created by Radyslav Krechet on 5/18/19.
//  Copyright © 2019 RubyGarage. All rights reserved.
//

import WatchKit

class TodayInterfaceController: WKInterfaceController, PreparationController {
    @IBOutlet weak var noWorkLabel: WKInterfaceLabel!
    @IBOutlet weak var table: WKInterfaceTable!

    private var habits: [Habit] = []
    private var activities: [Activity] = []
    
    // MARK: - Interface Controller Lifecycle

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        prepareController()
    }

    override func didAppear() {
        super.didAppear()

        prepareController()
    }

    override func contextForSegue(withIdentifier segueIdentifier: String,
                                  in table: WKInterfaceTable,
                                  rowIndex: Int) -> Any? {

        return habits[rowIndex].id
    }

    // MARK: - PreparationController

    func prepareController() {
        loadData()
        populateViewsWithHabits()
    }

    // MARK: - Setup

    private func loadData() {
        habits = HabitService.todayHabits
        activities = ActivityService.todayActivities
    }

    private func populateViewsWithHabits() {
        noWorkLabel.setHidden(!habits.isEmpty)
        table.setNumberOfRows(habits.count, withRowType: "habit")
        for index in 0..<habits.count {
            if let row = table.rowController(at: index) as? HabitRow {
                let habit = habits[index]
                let activity = activities[index]
                let rate = "\(SummaryService.rate(withGoal: habit.goal, done: activity.done))%"
                row.nameLabel.setText(habit.name)
                row.rateLabel.setText(rate)
            }
        }
    }
}

//
//  HabitInterfaceController.swift
//  WatchMe WatchKit App Extension
//
//  Created by Radyslav Krechet on 5/19/19.
//  Copyright © 2019 RubyGarage. All rights reserved.
//

import WatchKit

class HabitInterfaceController: WKInterfaceController, PreparationController {
    @IBOutlet weak var nameLabel: WKInterfaceLabel!
    @IBOutlet weak var rateLabel: WKInterfaceLabel!
    @IBOutlet weak var doneButton: WKInterfaceButton!
    @IBOutlet weak var undoButton: WKInterfaceButton!

    private var habitId: UUID!
    private var habit: Habit!
    private var activity: Activity!
    private var extensionDelegate: ExtensionDelegate?

    // MARK: - Interface Controller Lifecycle

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        habitId = context as? UUID
        prepareController()

        extensionDelegate = WKExtension.shared().delegate as? ExtensionDelegate
    }

    // MARK: - Setup

    func prepareController() {
        loadData()
        populateViewsWithHabit()
    }

    private func loadData() {
        habit = HabitService.todayHabits.first { $0.id == habitId }
        activity = ActivityService.todayActivities.first { $0.habitId == habitId }
    }

    private func populateViewsWithHabit() {
        nameLabel.setText(habit.name)
        rateLabel.setText("\(activity.done)/\(habit.goal)")
        doneButton.setEnabled(activity.done < habit.goal)
        undoButton.setEnabled(activity.done > 0)
    }

    // MARK: - Actions

    @IBAction func doneButtonDidPress() {
        ActivityService.doneActivity(forHabitWithId: habit.id)
        prepareController()

        extensionDelegate?.doneActivity(forHabitWithId: habit.id)
    }

    @IBAction func undoButtonDidPress() {
        ActivityService.undoActivity(forHabitWithId: habit.id)
        prepareController()

        extensionDelegate?.undoActivity(forHabitWithId: habit.id)
    }
}

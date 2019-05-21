//
//  TodayViewController.swift
//  WatchMe
//
//  Created by Radyslav Krechet on 5/19/19.
//  Copyright © 2019 RubyGarage. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var completionRateLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var startedLabel: UILabel!
    @IBOutlet weak var notDoneLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    private var habits: [Habit] = []
    private var goals: [Goal] = []
    private var summary: Summary!
    
    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        GoalService.prepareGoals()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        prepareController()
    }

    // MARK: - Setup

    private func prepareController() {
        loadData()
        populateViewsWithSummary()
        tableView.reloadData()
    }

    private func loadData() {
        habits = HabitService.todayHabits
        goals = GoalService.allGoals
        summary = SummaryService.summary(withHabits: habits, goals: goals)
    }

    private func populateViewsWithSummary() {
        completionRateLabel.text = summary.completionRate
        completedLabel.text = summary.completed
        startedLabel.text = summary.started
        notDoneLabel.text = summary.notDone
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "habitWithRate", for: indexPath)
        if let cell = cell as? TodayTableViewCell {
            let habit = habits[indexPath.row]
            let goal = goals[indexPath.row]
            cell.nameLabel.text = habit.name
            cell.rateLabel.text = SummaryService.rate(withGoal: habit.goal, done: goal.done)
        }
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let habit = habits[indexPath.row]
        let goal = goals[indexPath.row]

        let doneAlertAction = UIAlertAction(title: "Done", style: .default) { _ in
            GoalService.doneGoal(forHabitWithId: habit.id)
            self.prepareController()
        }
        doneAlertAction.isEnabled = goal.done < habit.goal

        let undoAlertAction = UIAlertAction(title: "Undo", style: .default) { _ in
            GoalService.undoGoal(forHabitWithId: habit.id)
            self.prepareController()
        }
        undoAlertAction.isEnabled = goal.done > 0

        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel)

        let message = "\(goal.done)/\(habit.goal)"
        let alertController = UIAlertController(title: habit.name, message: message, preferredStyle: .alert)
        alertController.addAction(doneAlertAction)
        alertController.addAction(undoAlertAction)
        alertController.addAction(cancelAlertAction)

        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
}

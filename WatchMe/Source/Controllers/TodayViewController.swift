//
//  TodayViewController.swift
//  WatchMe
//
//  Created by Radyslav Krechet on 5/19/19.
//  Copyright © 2019 RubyGarage. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController, PreparationController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var completionRateLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var startedLabel: UILabel!
    @IBOutlet weak var notDoneLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    private var habits: [Habit] = []
    private var activities: [Activity] = []
    private var summary: Summary!
    
    // MARK: - View Controller Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        prepareController()
    }

    // MARK: - PreparationControllerup

    func prepareController() {
        loadData()
        populateViewsWithSummary()
        tableView.reloadData()
    }

    // MARK: - Setup

    private func loadData() {
        habits = HabitService.todayHabits
        activities = ActivityService.todayActivities
        summary = SummaryService.todaySummary
    }

    private func populateViewsWithSummary() {
        completionRateLabel.text = "\(summary.completionRate)%"
        completedLabel.text = String(summary.completed)
        startedLabel.text = String(summary.started)
        notDoneLabel.text = String(summary.notDone)
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "habitWithRate", for: indexPath)
        if let cell = cell as? TodayTableViewCell {
            let habit = habits[indexPath.row]
            let activity = activities[indexPath.row]
            let rate = "\(SummaryService.rate(withGoal: habit.goal, done: activity.done))%"
            cell.nameLabel.text = habit.name
            cell.rateLabel.text = rate
        }
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let habit = habits[indexPath.row]
        let activity = activities[indexPath.row]

        let doneAlertAction = UIAlertAction(title: "Done", style: .default) { [unowned self] _ in
            ActivityService.doneActivity(forHabitWithId: habit.id)
            self.prepareController()
        }
        doneAlertAction.isEnabled = activity.done < habit.goal

        let undoAlertAction = UIAlertAction(title: "Undo", style: .default) { [unowned self] _ in
            ActivityService.undoActivity(forHabitWithId: habit.id)
            self.prepareController()
        }
        undoAlertAction.isEnabled = activity.done > 0

        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel)

        let message = "\(activity.done)/\(habit.goal)"
        let alertController = UIAlertController(title: habit.name, message: message, preferredStyle: .alert)
        alertController.addAction(doneAlertAction)
        alertController.addAction(undoAlertAction)
        alertController.addAction(cancelAlertAction)

        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
}

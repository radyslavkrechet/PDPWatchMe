//
//  AllViewController.swift
//  WatchMe
//
//  Created by Radyslav Krechet on 5/19/19.
//  Copyright © 2019 RubyGarage. All rights reserved.
//

import UIKit

class AllViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    private var habits: [Habit] = []

    // MARK: - View Controller Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        prepareController()
    }

    // MARK: - Setup

    private func prepareController() {
        loadData()
        tableView.reloadData()
    }

    private func loadData() {
        habits = HabitService.allHabits
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "habit", for: indexPath)
        if let cell = cell as? AllTableViewCell {
            let habit = habits[indexPath.row]
            cell.nameLabel.text = habit.name
        }
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let habit = habits[indexPath.row]

        let deleteAlertAction = UIAlertAction(title: "Delete", style: .destructive) { [unowned self] _ in
            HabitService.deleleHabit(atIndex: indexPath.row)
            self.prepareController()
        }

        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel)

        let alertController = UIAlertController(title: habit.name, message: nil, preferredStyle: .alert)
        alertController.addAction(deleteAlertAction)
        alertController.addAction(cancelAlertAction)

        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
}

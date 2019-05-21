//
//  AddViewController.swift
//  WatchMe
//
//  Created by Radyslav Krechet on 5/19/19.
//  Copyright © 2019 RubyGarage. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var goalSegmentedControl: UISegmentedControl!
    @IBOutlet var weekdayButtons: [UIButton]!

    var brandColor: UIColor {
        return UIColor(named: "Brand") ?? UIColor.white
    }

    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    // MARK: - Setup

    private func setupViews() {
        weekdayButtons.forEach { button in
            button.layer.cornerRadius = 6
            button.layer.borderWidth = 1
            button.layer.borderColor = brandColor.cgColor
        }
    }

    // MARK: - Actions

    @IBAction func weekdayButtonDidPress(_ sender: UIButton) {
        guard let weekday = WeekdayState(rawValue: sender.tag) else {
            return
        }

        switch weekday {
        case .unselect:
            sender.backgroundColor = brandColor
            sender.setTitleColor(UIColor.white, for: .normal)
            sender.tag = WeekdayState.select.rawValue
        case .select:
            sender.backgroundColor = UIColor.white
            sender.setTitleColor(brandColor, for: .normal)
            sender.tag = WeekdayState.unselect.rawValue
        }
    }


    @IBAction func addButtonDidPress(_ sender: Any) {
        guard let name = nameTextField.text else {
            return
        }

        let weekdays = weekdayButtons.compactMap { WeekdayState(rawValue: $0.tag) }
        guard weekdays.count == weekdayButtons.count else {
            return
        }

        HabitService.addHabit(withName: name,
                              goal: goalSegmentedControl.selectedSegmentIndex + 1,
                              weekdays: weekdays)

        navigationController?.popViewController(animated: true)
    }
}

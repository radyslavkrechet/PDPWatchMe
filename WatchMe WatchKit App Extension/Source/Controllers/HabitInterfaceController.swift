//
//  HabitInterfaceController.swift
//  WatchMe WatchKit App Extension
//
//  Created by Radyslav Krechet on 5/19/19.
//  Copyright © 2019 RubyGarage. All rights reserved.
//

import WatchKit

class HabitInterfaceController: WKInterfaceController {
    @IBOutlet weak var nameLabel: WKInterfaceLabel!
    @IBOutlet weak var rateLabel: WKInterfaceLabel!
    @IBOutlet weak var doneButton: WKInterfaceButton!
    @IBOutlet weak var undoButton: WKInterfaceButton!

    // MARK: - Interface Controller Lifecycle

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        populateViewsWithHabit()
        setupViews()
    }

    // MARK: - Setup

    private func populateViewsWithHabit() {
        nameLabel.setText("Test")
        rateLabel.setText("1/1")
    }

    private func setupViews() {
        doneButton.setEnabled(false)
        undoButton.setEnabled(false)
    }

    // MARK: - Actions

    @IBAction func doneButtonDidPress() {
        //
    }

    @IBAction func undoButtonDidPress() {
        //
    }
}

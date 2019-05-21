//
//  TodayInterfaceController.swift
//  WatchMe WatchKit App Extension
//
//  Created by Radyslav Krechet on 5/18/19.
//  Copyright © 2019 RubyGarage. All rights reserved.
//

import WatchKit

class TodayInterfaceController: WKInterfaceController {
    @IBOutlet weak var table: WKInterfaceTable!

    // MARK: - Interface Controller Lifecycle
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        populateTableWithHabits()
    }

    // MARK: - Setup

    private func populateTableWithHabits() {
        table.setNumberOfRows(1, withRowType: "habit")
        if let row = table.rowController(at: 0) as? HabitRow {
            row.nameLabel.setText("Test")
            row.rateLabel.setText("100%")
        }
    }
}

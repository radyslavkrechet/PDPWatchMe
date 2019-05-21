//
//  SummaryInterfaceController.swift
//  WatchMe WatchKit App Extension
//
//  Created by Radyslav Krechet on 5/19/19.
//  Copyright © 2019 RubyGarage. All rights reserved.
//

import WatchKit

class SummaryInterfaceController: WKInterfaceController {
    @IBOutlet weak var completionRateLabel: WKInterfaceLabel!
    @IBOutlet weak var completedLabel: WKInterfaceLabel!
    @IBOutlet weak var startedLabel: WKInterfaceLabel!
    @IBOutlet weak var notDoneLabel: WKInterfaceLabel!

    // MARK: - Interface Controller Lifecycle

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        populateViewsWithSummary()
    }

    // MARK: - Setup

    private func populateViewsWithSummary() {
        completionRateLabel.setText("100%")
        completedLabel.setText("1")
        startedLabel.setText("1")
        notDoneLabel.setText("1")
    }
}

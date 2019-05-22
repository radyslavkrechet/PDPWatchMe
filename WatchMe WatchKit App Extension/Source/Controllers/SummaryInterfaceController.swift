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

    private var summary: Summary!

    // MARK: - Interface Controller Lifecycle

    override func didAppear() {
        super.didAppear()

        loadData()
        populateViewsWithSummary()
    }

    // MARK: - Setup

    private func loadData() {
        summary = SummaryService.todaySummary
    }

    private func populateViewsWithSummary() {
        completionRateLabel.setText("\(summary.completionRate)%")
        completedLabel.setText(String(summary.completed))
        startedLabel.setText(String(summary.started))
        notDoneLabel.setText(String(summary.notDone))
    }
}

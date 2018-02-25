//
//  MinerViewController.swift
//  BurstXBundle
//
//  Created by Andrew Scott on 2/5/18.
//

import Cocoa

class MinerViewController: NSViewController {

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Libs
    let util = Util()
    let miner = MinerHelper()

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Local vars

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Outlets
    @IBOutlet weak var minerStatusLabel: NSTextField!
    @IBOutlet weak var minerStatusIndicatorLabel: NSTextField!
    @IBOutlet weak var minerConfigurationLabel: NSTextField!
    @IBOutlet weak var minerMiningInfoLabel: NSTextField!
    @IBOutlet weak var minerMiningInfoTextField: NSTextField!
    @IBOutlet weak var minerSubmissionLabel: NSTextField!
    @IBOutlet weak var minerSubmissionTextField: NSTextField!
    @IBOutlet weak var minerWalletLabel: NSTextField!
    @IBOutlet weak var minerWalletTextField: NSTextField!
    @IBOutlet weak var minerTargetDeadlineLabel: NSTextField!
    @IBOutlet weak var minerTargetDeadlineTextField: NSTextField!
    @IBOutlet weak var minerPlotFilesLabel: NSTextField!
    @IBOutlet var minerPlotFilesTextView: NSTextView!
    @IBOutlet weak var minerHelpButton: NSButton!
    @IBOutlet weak var minerStartMiningButton: NSButton!
    @IBOutlet weak var minerGoToMiningButton: NSButton!

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        self.minerNotFound()
        Logger.log(message: "Miner Tab opened.", event: .debug)
        if miner.isMinerInstalled() {
            Logger.log(message: "Miner is installed.", event: .info)
            self.minerReady()
        } else {
            Logger.log(message: "Miner is not installed.", event: .warn)
            miner.installMiner()
            if miner.isMinerInstalled() {
                self.minerReady()
            }
        }
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Actions
    @IBAction func minerStartMiningButtonClick(_ sender: NSButton) {
        miner.configureMiner(config: MinerRequest(miningInfo: "", submission: "", wallet: "", targetDeadline: "", plotFiles: [""]))
    }

    @IBAction func minerHelpButtonClick(_ sender: NSButton) {
        if let url = URL(string: "https://github.com/beatsbears/BurstXBundle/wiki/Miner"), NSWorkspace.shared.open(url) {}
    }

    @IBAction func minerGoToMiningButtonClick(_ sender: NSButton) {
        if let url = URL(string: "http://localhost:8080"), NSWorkspace.shared.open(url) {}
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Helpers
    func minerNotFound() {
        self.minerStatusIndicatorLabel.stringValue = "Not Found"
        self.minerStatusIndicatorLabel.backgroundColor = NSColor.red
        self.minerStartMiningButton.title = "Start Mining"
        self.minerStartMiningButton.isEnabled = false
        self.minerGoToMiningButton.isEnabled = false
    }

    func minerReady() {
        self.minerStatusIndicatorLabel.stringValue = "Ready"
        self.minerStatusIndicatorLabel.backgroundColor = NSColor.orange
        self.minerStartMiningButton.title = "Start Mining"
        self.minerStartMiningButton.isEnabled = true
        self.minerGoToMiningButton.isEnabled = false
    }

    func minerRunning() {
        self.minerStatusIndicatorLabel.stringValue = "Running"
        self.minerStatusIndicatorLabel.backgroundColor = NSColor.green
        self.minerStartMiningButton.title = "Stop Mining"
        self.minerStartMiningButton.isEnabled = true
        self.minerGoToMiningButton.isEnabled = true
    }
}

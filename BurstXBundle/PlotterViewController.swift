//
//  PlotterViewController.swift
//  BurstXBundle
//
//  Created by Andrew Scott on 2/5/18.
//  https://github.com/k06a/mjminer

import Cocoa

class PlotterViewController: NSViewController {

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Libs
    let util = Util()
    let plotter = PlotterHelper()
    let config = Config()

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Local vars
    var fileLocation: URL = URL(string: "file:///Volumes")! // default plot location
    var fileLocationPath: String = ""
    var maxMemory: Int = 0 // GB of installed RAM
    var maxThreads: Int = 0 // CPU Cores
    var maxPlotSize: Int = 0 // Available space in selected directory
    var cpuMode: Int = 0
    var timer: Timer = Timer()

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Outlets
    @IBOutlet weak var plotterStatusLabel: NSTextField!
    @IBOutlet weak var plotterStatusIndicatorLabel: NSTextField!
    @IBOutlet weak var plotterFileSelectorButton: NSButton!
    @IBOutlet weak var plotterFileSelectorPath: NSPathControl!
    @IBOutlet weak var plotterStartPlottingButton: NSButton!
    @IBOutlet weak var plotterWalletIDTextField: NSTextField!
    @IBOutlet weak var plotterStartingNonceTextField: NSTextField!
    @IBOutlet weak var plotterMemUsageTextField: NSTextField!
    @IBOutlet weak var plotterMemUsageStepper: NSStepper!
    @IBOutlet weak var plotterPlotSizeTextField: NSTextField!
    @IBOutlet weak var plotterPlotSizeStepper: NSStepper!
    @IBOutlet weak var plotterThreadCountTextField: NSTextField!
    @IBOutlet weak var plotterThreadCountStepper: NSStepper!
    @IBOutlet weak var plotterHelpButton: NSButton!
    @IBOutlet weak var plotterProgressBar: NSProgressIndicator!
    @IBOutlet weak var plotterProgressPercentLabel: NSTextField!
    @IBOutlet weak var plotterDebugLabel: NSTextField!
    @IBOutlet weak var plotterCPURadio0: NSButton!
    @IBOutlet weak var plotterCPURadio1: NSButton!
    @IBOutlet weak var plotterCPURadio2: NSButton!
    @IBOutlet weak var plotterResetButton: NSButton!

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log(message: "Plotter Tab opened.", event: .debug)

        self.plotterProgressBar.isHidden = true
        self.plotterProgressPercentLabel.isHidden = true
        self.plotterDebugLabel.isHidden = true
        self.plotterResetButton.isHidden = true

        self.plotterFileSelectorPath.url = self.fileLocation
        // Do view setup here.
        if self.plotter.maxCompileOption == 1 {
            self.plotterCPURadio2.isEnabled = false
            self.plotterCPURadio1.state = NSControl.StateValue.on
        } else if self.plotter.maxCompileOption == 0 {
            self.plotterCPURadio1.isEnabled = false
            self.plotterCPURadio2.isEnabled = false
        }
        self.cpuMode = self.plotter.maxCompileOption

        if !self.plotter.isPlotterInstalled() {
            if self.plotter.maxCompileOption == 2 {
                self.plotter.installPlotter(cpuMode: 1)
            } else {
                self.plotter.installPlotter(cpuMode: 0)
            }
        }

        self.plotterWalletIDTextField.stringValue = config.read(key: "account_id_num")
        self.fileLocationPath = self.fileLocation.path
        self.plotterMemUsageTextField.stringValue = String(self.plotter.maxMemory) + " GB"
        self.plotterMemUsageStepper.integerValue = Int(self.plotter.maxMemory)
        self.plotterThreadCountTextField.stringValue = String(self.plotter.maxThreads)
        self.plotterThreadCountStepper.integerValue = Int(self.plotter.maxThreads)
        let tmpPlotSize = String(self.plotter.getOpenSpace(path: self.fileLocation.path))
        self.plotterPlotSizeTextField.stringValue = tmpPlotSize + " GB"
        self.plotterPlotSizeStepper.integerValue = Int(tmpPlotSize)!
        self.plotterStartingNonceTextField.stringValue = "0"
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Actions
    @IBAction func plotterFileButtonClick(_ sender: NSButton) {
        let openPanel = NSOpenPanel()
        _ =  FileManager.default.urls(for: .userDirectory, in: .userDomainMask).first
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.canChooseFiles = false
        openPanel.begin { (result) -> Void in
            if result.rawValue == NSFileHandlingPanelOKButton {

                // save the new url locally
                self.fileLocation = openPanel.directoryURL
                    ?? URL(string: "file:///Volumes")!

                // set the visual to use the new URL
                self.plotterFileSelectorPath.url = self.fileLocation
                self.fileLocationPath = self.fileLocation.path
                let openSpace: Int = self.plotter.getOpenSpace(path: self.fileLocationPath)
                self.plotterPlotSizeTextField.stringValue =
                    String(openSpace) + " GB"
                self.plotterPlotSizeStepper.integerValue = openSpace
                Logger.log(message: "New plot location selected: " + self.fileLocation.path, event: .info)
            }
        }
    }

    @IBAction func plotterStartPlottingButtonClick(_ sender: NSButton) {
        let plotRequest = PlotterRequest(address: self.plotterWalletIDTextField.stringValue,
                                         path: self.fileLocationPath,
                                         startingNonce: self.plotterStartingNonceTextField.stringValue,
                                         nonces: self.plotterPlotSizeTextField.stringValue,
                                         staggerSize: self.plotterMemUsageTextField.stringValue,
                                         threads: self.plotterThreadCountTextField.stringValue,
                                         coreMode: self.plotter.maxCompileOption)
        Logger.log(message: "Start plotting request sent.", event: .info)
        showStartAlert(plotRequest: plotRequest)
    }

    @IBAction func plotterCPUModeRadioClick(_ sender: NSButton) {
        self.cpuMode = Int(sender.keyEquivalent)!
    }

    @IBAction func plotterHelpButtonCLick(_ sender: NSButton) {
        if let url = URL(string: "https://github.com/beatsbears/BurstXBundle/wiki/Plotter"), NSWorkspace.shared.open(url) {}
    }

    @IBAction func plotterMemUsageStepperClick(_ sender: NSStepper) {
        if sender.integerValue >= self.plotter.maxMemory {
            sender.integerValue = self.plotter.maxMemory
        }
        self.plotterMemUsageTextField.stringValue = String(sender.integerValue) + " GB"
    }

    @IBAction func plotterThreadCountStepperClick(_ sender: NSStepper) {
        if sender.integerValue >= self.plotter.maxThreads {
            sender.integerValue = self.plotter.maxThreads
        }
        self.plotterThreadCountTextField.stringValue = String(sender.integerValue)
    }

    @IBAction func plotterPlotSizeStepperClick(_ sender: NSStepper) {
        let tmpPlotSize = self.plotter.getOpenSpace(path: self.fileLocation.path)
        if sender.integerValue >= tmpPlotSize {
            sender.integerValue = tmpPlotSize
        }
        self.plotterPlotSizeTextField.stringValue = String(sender.integerValue) + " GB"
    }

    @IBAction func plotterResetButtonClick(_ sender: NSButton) {
        self.plotterProgressBar.isHidden = true
        self.plotterProgressPercentLabel.isHidden = true
        self.plotterDebugLabel.isHidden = true

        self.fileLocationPath = self.fileLocation.path
        self.maxMemory = self.plotter.getMaxMemory()
        self.maxThreads = self.plotter.getMaxThreads()
        self.plotterMemUsageTextField.stringValue = String(self.maxMemory) + " GB"
        self.plotterMemUsageStepper.integerValue = Int(self.maxMemory)
        self.plotterThreadCountTextField.stringValue = String(self.maxThreads)
        self.plotterThreadCountStepper.integerValue = Int(self.maxThreads)
        let tmpPlotSize = String(self.plotter.getOpenSpace(path: self.fileLocationPath))
        self.plotterPlotSizeTextField.stringValue = tmpPlotSize + " GB"
        self.plotterPlotSizeStepper.integerValue = Int(tmpPlotSize)!
        self.plotterStartingNonceTextField.stringValue = "0"
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Functions
    func startPlotting() {
        self.plotterStatusIndicatorLabel.stringValue = "Plotting"
        self.plotterStatusIndicatorLabel.backgroundColor = NSColor.green
        self.plotterProgressBar.isHidden = false
        self.plotterProgressPercentLabel.isHidden = false
        self.plotterDebugLabel.isHidden = false

        self.plotterProgressBar.minValue = 0.0
        self.plotterProgressBar.maxValue = 100.0

        self.plotterProgressBar.startAnimation(self)
        self.plotterProgressPercentLabel.stringValue = "0 %"
        self.plotterDebugLabel.stringValue = "Starting plotter"

        self.plotterStartPlottingButton.isEnabled = false

        self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(PlotterViewController.checkStatus), userInfo: nil, repeats: true)
    }

    func stopPlotting() {
        Logger.log(message: "Plotting complete.", event: .info)
        self.plotterStatusIndicatorLabel.stringValue = "Idle"
        self.plotterStatusIndicatorLabel.backgroundColor = NSColor.orange
        self.plotterDebugLabel.stringValue = "Done"
        self.plotterStartPlottingButton.isEnabled = true
        self.timer.invalidate()
        self.plotterResetButton.isHidden = false
    }

    @objc func checkStatus() {
        let plotStats: [String: String] = plotter.getPlotterStatus()

        DispatchQueue.main.async {
            if plotStats["status"]! == "Initializing" {
                self.plotterDebugLabel.stringValue = plotStats["status"]!
            } else if plotStats["status"]! == "Plotting" {
                self.plotterProgressPercentLabel.stringValue = plotStats["pct"]! + "%"
                self.plotterProgressBar.doubleValue = Double(plotStats["pct"]!)!
                self.plotterDebugLabel.stringValue = plotStats["status"]! + " at " + plotStats["speed"]! + " nonces/minute"
            } else if plotStats["status"]! == "Finished" {
                self.plotterProgressPercentLabel.stringValue = plotStats["pct"]! + "%"
                self.plotterProgressBar.doubleValue = Double(plotStats["pct"]!)!
                self.stopPlotting()
            }
        }
    }

    func showStartAlert(plotRequest: PlotterRequest) {
        let alert = NSAlert()
        alert.messageText = "Are you sure?"
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        alert.informativeText = "Are you sure you want to start plotting using these settings? \n\nWallet ID: \(plotRequest.address) \nFile Path: \(plotRequest.path) \nStarting Nonce: \(plotRequest.startingNonce) \nTotal Plot Size: \(plotRequest.nonces) \nStagger Size: \(plotRequest.staggerSize) \nThreads: \(plotRequest.threads) \nCore Mode: \(plotRequest.coreMode)"
        alert.beginSheetModal(for: self.view.window!) { (resp: NSApplication.ModalResponse) -> Void in
            switch resp.rawValue {
            case 1000:
                Logger.log(message: "Confirm Start plotting", event: .debug)
                self.plotter.plotFile(request: plotRequest)
                self.startPlotting()
            case 1001:
                Logger.log(message: "Cancel Start plotting", event: .debug)
            default:
                Logger.log(message: "Unknown event", event: .warn)
            }
        }
    }
}

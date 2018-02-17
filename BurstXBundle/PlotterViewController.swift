//
//  PlotterViewController.swift
//  BurstXBundle
//
//  Created by Andrew Scott on 2/5/18.
//  https://github.com/k06a/mjminer
//  https://github.com/DylanHenderson/Burst-Plot-Integrity-Checker

import Cocoa

class PlotterViewController: NSViewController {

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Libs
    let util = Util()
    let plotter = PlotterHelper()

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

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        self.plotterProgressBar.isHidden = true
        self.plotterProgressPercentLabel.isHidden = true
        self.plotterDebugLabel.isHidden = true

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
            }
        }
    }

    @IBAction func plotterStartPlottingButtonClick(_ sender: NSButton) {
        self.plotter.plotFile(address: self.plotterWalletIDTextField.stringValue,
                              filePath: self.fileLocationPath,
                              startingNonce: self.plotterStartingNonceTextField.stringValue,
                              nonces: self.plotterPlotSizeTextField.stringValue,
                              staggerSize: self.plotterMemUsageTextField.stringValue,
                              threads: self.plotterThreadCountTextField.stringValue,
                              coreMode: String(self.plotter.maxCompileOption))
        self.startPlotting()
    }

    @IBAction func plotterCPUModeRadioClick(_ sender: NSButton) {
        self.cpuMode = Int(sender.keyEquivalent)!
    }

    @IBAction func plotterHelpButtonCLick(_ sender: NSButton) {
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

        self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(PlotterViewController.checkStatus), userInfo: nil, repeats: true)
    }

    func stopPlotting() {
        self.plotterStatusIndicatorLabel.stringValue = "Idle"
        self.plotterStatusIndicatorLabel.backgroundColor = NSColor.orange
        self.plotterDebugLabel.stringValue = "Done"
        self.plotterStartPlottingButton.isEnabled = true
        self.timer.invalidate()
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
}

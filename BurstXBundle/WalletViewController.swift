//
//  WalletViewController.swift
//  BurstXBundle
//
//  Created by Andrew Scott on 2/2/18.
//

import Cocoa

class WalletViewController: NSViewController {

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Libs
    let dependency = DependencyInstaller()
    let util = Util()
    let wallet = WalletHelper()

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Local Variables
    var STATE = "Not Found" // "Offline" "Running"

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Outlets
    @IBOutlet weak var walletStatusLabel: NSTextField!
    @IBOutlet weak var walletStatusIndicatorLabel: NSTextField!
    @IBOutlet weak var walletVersionLabel: NSTextField!
    @IBOutlet weak var walletVersionIndicatorLabel: NSTextField!
    @IBOutlet weak var walletActionButton: NSButton!
    @IBOutlet weak var walletGoToButton: NSButton!
    @IBOutlet weak var walletDetailsButton: NSButton!
    @IBOutlet weak var walletProgressMeter: NSProgressIndicator!
    @IBOutlet weak var walletDebugOutput: NSTextField!
    @IBOutlet weak var walletHelpButton: NSButton!
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log(message: "Wallet Tab opened.", event: .debug)
        determineLoadState()
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Actions

    @IBAction func walletActionButtonClick(_ sender: NSButton) {
        if self.STATE == "Not Found" {
            Logger.log(message: "Wallet not found.", event: .info)
            runInstallerCheck()
        }
        if self.STATE == "Offline" {
            Logger.log(message: "Wallet is starting.", event: .info)
            self.walletStateRunning()
            _ = wallet.startWallet()
        }
        if self.STATE == "Running" {
            Logger.log(message: "Wallet is stopping.", event: .info)
            _ = wallet.stopWallet()
            walletStateOffline()
        }
    }

    @IBAction func walletGoToButtonClick(_ sender: NSButton) {
        // Opens wallet for use
        Logger.log(message: "Open Wallet.", event: .debug)
        openWallet()
    }

    @IBAction func walletDetailsButtonClick(_ sender: NSButton) {
        // Opens POC Wallet github
        Logger.log(message: "Open Wallet Github.", event: .debug)
        openGithub()
    }

    @IBAction func walletHelpButtonClick(_ sender: NSButton) {
        if let url = URL(string: "https://github.com/beatsbears/BurstXBundle/wiki/Wallet"), NSWorkspace.shared.open(url) {}
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Helpers
    func walletStateNotFound() {
        DispatchQueue.main.async {
            self.STATE = "Not Found"
            self.walletStatusIndicatorLabel.stringValue = self.STATE
            self.walletStatusIndicatorLabel.backgroundColor = NSColor.red
            self.walletActionButton.title = "Install"
            self.walletGoToButton.isEnabled = false
        }
    }

    func walletStateOffline() {
        DispatchQueue.main.async {
            self.STATE = "Offline"
            self.walletStatusIndicatorLabel.stringValue = self.STATE
            self.walletStatusIndicatorLabel.backgroundColor = NSColor.orange
            self.walletActionButton.title = "Start"
            self.walletGoToButton.isEnabled = false
        }
    }

    func walletStateRunning() {
        DispatchQueue.main.async {
            self.STATE = "Running"
            self.walletStatusIndicatorLabel.stringValue = self.STATE
            self.walletStatusIndicatorLabel.backgroundColor = NSColor.green
            self.walletActionButton.title = "Stop"
            self.walletGoToButton.isEnabled = true
        }
    }

    func runInstallerCheck() {
        Logger.log(message: "Running installer check.", event: .info)
        DispatchQueue.main.async {
            self.walletProgressMeter.isHidden = false
            self.walletProgressMeter.isIndeterminate = true
            self.walletProgressMeter.startAnimation(self)
            self.walletDebugOutput.isHidden = false
            self.walletDebugOutput.stringValue = "Checking dependencies. You may be asked to provide your password."
        }

        // Check dependencies and show alert to confirm install of any missing dependencies
        let missingDependencies = !dependency.checkInstalled()
        if missingDependencies {
            showInstallerAlert(missing: dependency.needInstalled)
        }
    }

    func finishInstaller(missing: [String: Bool]) {
        dependency.runInstaller(missing: missing)
        util.delay(count: 10, closure: { self.showInstallSuccessfulAlert() })
    }

    func showInstallerAlert(missing: [String: Bool]) {
        let alert = NSAlert()
        alert.messageText = "Missing Dependencies"
        alert.addButton(withTitle: "OK")
        alert.informativeText =
            "Please confirm installation of missing dependencies: "
            + Array(missing.keys).joined(separator: "\n ")
        alert.beginSheetModal(for: self.view.window!) { (_: NSApplication.ModalResponse) -> Void in
            self.finishInstaller(missing: missing)
        }
    }

    func showInstallSuccessfulAlert() {
        let alert = NSAlert()
        alert.messageText = "Install Successful"
        alert.addButton(withTitle: "OK")
        alert.showsHelp = true
        alert.informativeText = "Dependencies Install successfully!"
        alert.beginSheetModal(for: self.view.window!) { (_: NSApplication.ModalResponse) -> Void in
            self.walletProgressMeter.isHidden = true
            self.walletProgressMeter.stopAnimation(self)
            self.walletDebugOutput.isHidden = true
            self.walletDebugOutput.stringValue = "Installation Complete!"
            self.walletStateOffline()
            self.updateWalletVersion()
            self.util.setDefault(key: "DEPENDENCIES_MET", value: true)
        }
    }

    func openWallet() {
        if let url = URL(string: "http://localhost:8125/index.html"), NSWorkspace.shared.open(url) {}
    }

    func openGithub() {
        if let url = URL(string: "https://github.com/PoC-Consortium/burstcoin"), NSWorkspace.shared.open(url) {}
    }

    func updateWalletVersion() {
        let currentVersion = wallet.checkLatestWalletVersion()
        self.walletVersionIndicatorLabel.stringValue = currentVersion
        self.util.setDefault(key: "CURRENT_VERSION", value: currentVersion as AnyObject!)
    }

    func determineLoadState() {
        // Version
        let currentVersion = self.util.getDefault(key: "CURRENT_VERSION") as? String ?? "0.0.0"
        self.walletVersionIndicatorLabel.stringValue = currentVersion

        // Dependencies
        let dependenciesMet = self.util.getDefault(key: "DEPENDENCIES_MET", type: true)
        if dependenciesMet {
            // wallet installed
            if self.wallet.isWalletInstalled() {
                self.walletStateOffline()
            } else {
                self.walletStateNotFound()
            }
        } else {
            self.walletStateNotFound()
        }
    }
}

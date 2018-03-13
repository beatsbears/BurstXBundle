//
//  SettingsViewController.swift
//  BurstXBundle
//
//  Created by Andrew Scott on 3/9/18.
//

import Cocoa

class SettingsViewController: NSViewController {

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Libs
    let util = Util()
    let config = Config()

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Local vars
    var saveErrors: [String] = []

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Outlets
    @IBOutlet weak var settingsMainLabel: NSTextField!
    @IBOutlet weak var settingsWalletIDLabel: NSTextField!
    @IBOutlet weak var settingsWalletIdTextField: NSTextField!
    @IBOutlet weak var settingsNumericWalletIdLabel: NSTextField!
    @IBOutlet weak var settingsNumericWalletIdTextField: NSTextField!
    @IBOutlet weak var settingsAdvancedLabel: NSTextField!
    @IBOutlet weak var settingsWalletDBLabel: NSTextField!
    @IBOutlet weak var settingsWalletDBTextField: NSTextField!
    @IBOutlet weak var settingsWalletDBUserLabel: NSTextField!
    @IBOutlet weak var settingsWalletDBUserTextField: NSTextField!
    @IBOutlet weak var settingsWalletDBPasswordLabel: NSTextField!
    @IBOutlet weak var settingsWalletDBPasswordTextField: NSTextField!
    @IBOutlet weak var settingsMariaDBPasswordLabel: NSTextField!
    @IBOutlet weak var settingsMariaDBPasswordTextField: NSTextField!
    @IBOutlet weak var settingsHelpButton: NSButton!
    @IBOutlet weak var settingsSaveButton: NSButton!

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log(message: "Settings Tab opened.", event: .debug)

        // set initial values
        self.settingsWalletIdTextField.stringValue = config.read(key: "account_id_friendly")
        self.settingsNumericWalletIdTextField.stringValue = config.read(key: "account_id_num")

        // disable mariaDB root pw changes for now, this will be a future change
        self.settingsMariaDBPasswordLabel.isHidden = true
        self.settingsMariaDBPasswordTextField.isHidden = true
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Actions
    @IBAction func settingsHelpButtonClick(_ sender: NSButton) {
        if let url = URL(string: "https://github.com/beatsbears/BurstXBundle/wiki/Settings"), NSWorkspace.shared.open(url) {}
    }

    @IBAction func settingsSaveButtonClick(_ sender: NSButton) {
        if !WalletId.isValidId(walletId: self.settingsWalletIdTextField.stringValue) {
            self.saveErrors.append("Wallet ID format is invalid: \(self.settingsWalletIdTextField.stringValue) \nex. BURST-MVYC-B6MZ-7W9B-D7PJ9")
        }
        if !NumericWalletId.isValidId(walletId: self.settingsNumericWalletIdTextField.stringValue) {
            self.saveErrors.append("Numeric Wallet ID format is invalid: \(self.settingsNumericWalletIdTextField.stringValue) \nex. 12953097211892854730")
        }

        if self.saveErrors.count > 0 {
            showValidationErrorAlert(errors: self.saveErrors)
            self.saveErrors = []
        } else {
            showSaveAlert()
        }
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Helpers
    func showSaveAlert() {
        let alert = NSAlert()
        alert.messageText = "Are you Sure"
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        alert.informativeText = "Are you sure you want to save these settings?"
        alert.beginSheetModal(for: self.view.window!) { (resp: NSApplication.ModalResponse) -> Void in
            switch resp.rawValue {
            case 1000:
                Logger.log(message: "User Saving new settings", event: .debug)
                self.saveSettings()
                Logger.log(message: "Successfully saved new settings", event: .info)
            case 1001:
                Logger.log(message: "User cancelled settings save", event: .debug)
            default:
                Logger.log(message: "Unknown save event", event: .warn)
            }
        }
    }

    func showValidationErrorAlert(errors: [String]) {
        let alert = NSAlert()
        alert.messageText = "Error Saving Settings!"
        alert.addButton(withTitle: "OK")
        alert.informativeText = "Errors encountered saving..\n\n" + errors.joined(separator: "\n")
        alert.beginSheetModal(for: self.view.window!) { (_: NSApplication.ModalResponse) -> Void in
        }
    }

    func saveSettings() {
        config.update(key: "account_id_friendly", value: self.settingsWalletIdTextField.stringValue)
        config.update(key: "account_id_num", value: self.settingsNumericWalletIdTextField.stringValue)
    }
}

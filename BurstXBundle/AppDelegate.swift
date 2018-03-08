//
//  AppDelegate.swift
//  BurstXBundle
//
//  Created by Andrew Scott on 2/2/18.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let wallet = WalletHelper()
    let swiftBash = SwiftBasher()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Init logger Singleton
        _ = Logger()
        Logger.log(message: "Burst XBundle launched successfully", event: .info)
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as? String {
            Logger.log(message: "Version: " + version, event: .info)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        Logger.log(message: "Exit event triggered, stopping wallet", event: .info)
        _ = wallet.stopWallet()
    }

    @IBAction func openSupport(_ sender: NSMenuItem) {
        if let url = URL(string: "https://github.com/beatsbears/BurstXBundle/wiki"),
            NSWorkspace.shared.open(url) {}
    }

    @IBAction func goToAppLogs(_ sender: NSMenuItem) {
        _ = swiftBash.bash(command: "open", arguments: [Logger.logFile.absoluteString])
    }
}

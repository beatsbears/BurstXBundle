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
    let config = Config()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Init logger Singleton
        _ = Logger()
        Logger.log(message: "Burst XBundle launched successfully", event: .info)
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as? String {
            Logger.log(message: "Version: " + version, event: .info)
        }

        // Create Application directory in Library
        let appBaseDir: URL = FileManager.default.urls(for: FileManager.SearchPathDirectory.applicationSupportDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
        let appPath = appBaseDir.appendingPathComponent("BurstXBundle")
        do {
            try FileManager.default.createDirectory(atPath: appPath.path, withIntermediateDirectories: false, attributes: nil)
            Logger.log(message: "Work directory: " + appPath.absoluteString, event: .info)
        } catch let err as NSError {
            Logger.log(message: err.localizedDescription, event: .error)
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

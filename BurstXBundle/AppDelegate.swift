//
//  AppDelegate.swift
//  BurstXBundle
//
//  Created by Andrew Scott on 2/2/18.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func openSupport(_ sender: NSMenuItem) {
        if let url = URL(string: "https://github.com/beatsbears/BurstXBundle/wiki"),
            NSWorkspace.shared.open(url) {}
    }
}

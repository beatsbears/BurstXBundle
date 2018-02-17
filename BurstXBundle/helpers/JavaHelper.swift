//
//  JavaHelper.swift
//  BurstXBundle
//
//  Created by Andrew Scott on 2/3/18.
//

import Foundation

class JavaHelper {

    let swiftBash = SwiftBasher()

    // local vars
    var isInstalled: Bool = false

    // paths
    var pathIsInstalledScript: String = ""
    var pathInstaller: String = ""

    init() {
        let bundle = Bundle.main
        self.pathInstaller = bundle.path(forResource: "sig_JDK_8_Update_162", ofType: "pkg")!
        self.pathIsInstalledScript = bundle.path(forResource: "isJava8Installed", ofType: "sh")!
    }

    func isJava8Installed() -> Bool {
        // Return whether or not Java appears to be installed
        if swiftBash.bash(command: "sh", arguments: [self.pathIsInstalledScript]) == "1" {
            self.isInstalled = true
        }
        return self.isInstalled
    }

    func installJava() -> Bool {
        _ = swiftBash.bash(command: "open", arguments: [self.pathInstaller])
        self.isInstalled = true
        return self.isInstalled
    }
}

//
//  WalletHelper.swift
//  BurstXBundle
//
//  Created by Andrew Scott on 2/3/18.
//

import Foundation

class WalletHelper {

    let util = Util()
    let swiftBash = SwiftBasher()
    var isInstalled: Bool = false

    // paths
    var pathLatestVersion: String = ""
    var pathInstaller: String = ""
    var pathStarter: String = ""
    var pathStopper: String = ""
    var pathInstalled: String = ""

    init() {
        let bundle = Bundle.main
        self.pathInstaller = bundle.path(forResource: "wallet_install", ofType: "sh")!
        self.pathLatestVersion = bundle.path(forResource: "check_latest_wallet", ofType: "sh")!
        self.pathStarter = bundle.path(forResource: "wallet_start", ofType: "sh")!
        self.pathStopper = bundle.path(forResource: "wallet_stop", ofType: "sh")!
        self.pathInstalled = bundle.path(forResource: "is_wallet_installed", ofType: "sh")!
    }

    func isWalletInstalled() -> Bool {
        // Return whether or not Wallet appears to be installed
        if swiftBash.bash(command: "sh", arguments: [self.pathInstalled]) == "1" {
            self.isInstalled = true
        }
        return self.isInstalled
    }

    func installWallet() -> Bool {
        // Installs wallet and configures with values from mariaDB setup
        _ = swiftBash.bash(command: "sh", arguments: [self.pathInstaller, checkLatestWalletVersion()])
        return true
    }

    func checkLatestWalletVersion() -> String {
        // Gets latest release version from github
        let latestRelease = swiftBash.bash(command: "sh", arguments: [self.pathLatestVersion])
        return latestRelease
    }

    func startWallet() -> Bool {
        // Starts wallet
        DispatchQueue.global(qos: .default).async {
            _ = self.swiftBash.bash(command: "sh", arguments: [self.pathStarter, self.checkLatestWalletVersion()])
        }
        return true
    }

    func stopWallet() -> Bool {
        // Stops wallet processes
        DispatchQueue.global(qos: .default).async {
            _ = self.swiftBash.bash(command: "sh", arguments: [self.pathStopper])
        }
        return true
    }

    func getCurrentWalletVersion() -> String {
        // Returns the version set during installation
        return util.getDefault(key: "CURRENT_VERSION") as? String ?? "0.0.0"
    }

    func isWalletUpToDate() -> Bool {
        // Compares installed version with latest github release
        return getCurrentWalletVersion() == checkLatestWalletVersion()
    }

    func upgradeWallet() -> Bool {
        // inplace wallet upgrade
        return true
    }
}

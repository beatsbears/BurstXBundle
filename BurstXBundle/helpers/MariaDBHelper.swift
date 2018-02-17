//
//  MariaDBHelper.swift
//  BurstXBundle
//
//  Created by Andrew Scott on 2/3/18.
//

import Foundation

class MariaDBHelper {

    // helpers
    let swiftBash = SwiftBasher()
    let util = Util()

    // local vars
    var isInstalled: Bool = false
    var isDefaultPassword: Bool = false

    // paths
    var pathIsInstalledScript: String = ""
    var pathInstaller: String = ""
    var pathDBSetup: String = ""
    var pathCreateDBScript: String = ""
    var pathDBCheck: String = ""
    var pathCheckDBScript: String = ""

    init() {
        let bundle = Bundle.main
        self.pathIsInstalledScript = bundle.path(forResource: "is_maria_db_installed", ofType: "sh")!
        self.pathInstaller = bundle.path(forResource: "sig_mariadb-10.2.12-osx10.13-x86_64", ofType: "pkg")!
        self.pathDBSetup = bundle.path(forResource: "db_setup", ofType: "sh")!
        self.pathCreateDBScript = bundle.path(forResource: "create_database", ofType: "sh")!
        self.pathDBCheck = bundle.path(forResource: "db_check", ofType: "sh")!
        self.pathCheckDBScript = bundle.path(forResource: "is_maria_db_password_default", ofType: "sh")!
    }

    func isMariaDBInstalled() -> Bool {
        // Return whether or not mariaDB appears to be installed
        if swiftBash.bash(command: "sh", arguments: [self.pathIsInstalledScript]) == "1" {
            self.isInstalled = true
        }
        return self.isInstalled
    }

    func installMariaDB() -> Bool {
        // Open the installer pkg
        _ = swiftBash.bash(command: "open", arguments: [self.pathInstaller])
        return true
    }

    func waitForMariaDBInstallation() {
        var installed = false
        while installed == false {
            util.delay(count: 3, closure: {
                print("Checking if MariaDB is installed..")
            })
            installed = self.isMariaDBInstalled()
        }
        util.delay(count: 10, closure: { _ = self.createMariaDBDatabase() })
    }

    func createMariaDBDatabase() -> Bool {
        // create new DB for Burst Wallet
        print("create Burst DB")
        _ = swiftBash.bash(command: "sh", arguments: [self.pathDBSetup])
        return true
    }

    func isMariaDBPasswordSet() -> Bool {
        // Return whether or not mariaDB default password has been set
        if swiftBash.bash(command: "sh", arguments: [self.pathDBCheck]) == "1" {
            self.isDefaultPassword = true
        }
        return self.isDefaultPassword
    }

    func isMariaDBBurstReady() -> Bool {
        // Return whether the burst database and user exist on mariaDB
        if swiftBash.bash(command: "sh", arguments: [self.pathCheckDBScript]) == "1" {
            self.isDefaultPassword = true
        }
        return self.isDefaultPassword
    }

}

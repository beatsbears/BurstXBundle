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
    var isMariaDBReady: Bool = false

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
            Logger.log(message: "MariaDB appears to be install.", event: .info)
        } else {
            self.isInstalled = false
            Logger.log(message: "MariaDB does not appear to be install.", event: .warn)
        }
        return self.isInstalled
    }

    func installMariaDB() -> Bool {
        // Open the installer pkg
        Logger.log(message: "Starting MariaDB installer.", event: .info)
        _ = swiftBash.bash(command: "open", arguments: [self.pathInstaller])
        return true
    }

    func waitForMariaDBInstallation() {
        var installed = false
        while installed == false {
            util.delay(count: 3, closure: {
                Logger.log(message: "Checking if MariaDB install has completed...", event: .debug)
            })
            installed = self.isMariaDBInstalled()
        }
        util.delay(count: 10, closure: { _ = self.createMariaDBDatabase() })
    }

    func createMariaDBDatabase() -> Bool {
        // create new DB for Burst Wallet
        Logger.log(message: "Creating database for burst wallet.", event: .info)
        _ = swiftBash.bash(command: "sh", arguments: [self.pathDBSetup])
        return true
    }

    func isMariaDBPasswordSet() -> Bool {
        // Return whether or not mariaDB default password has been set
        if swiftBash.bash(command: "sh", arguments: [self.pathDBCheck]) == "1" {
            self.isDefaultPassword = true
            Logger.log(message: "MariaDB root password is default.", event: .info)
        } else {
            self.isDefaultPassword = false
            Logger.log(message: "MariaDB root password is unknown.", event: .error)
        }
        return self.isDefaultPassword
    }

    func isMariaDBBurstReady() -> Bool {
        // Return whether the burst database and user exist on mariaDB
        if swiftBash.bash(command: "sh", arguments: [self.pathCheckDBScript]) == "1" {
            self.isMariaDBReady = true
            Logger.log(message: "MariaDB is ready to run wallet.", event: .info)
        } else {
            self.isMariaDBReady = false
            Logger.log(message: "MariaDB is not ready to run wallet.", event: .error)
        }
        return self.isMariaDBReady
    }

}

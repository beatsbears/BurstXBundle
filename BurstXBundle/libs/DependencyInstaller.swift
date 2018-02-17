//
//  DependencyInstaller.swift
//  BurstXBundle
//
//  Created by Andrew Scott on 2/4/18.
//

import Foundation

class DependencyInstaller {

    // helpers
    let maria = MariaDBHelper()
    let java = JavaHelper()
    let wallet = WalletHelper()
    let util = Util()

    // local vars
    var isMariaDBInstalled: Bool = false
    var isMariaDBReady: Bool = false
    var isMariaDBDefaultPassword: Bool = false
    var isJavaInstalled: Bool = false
    var isWalletInstalled: Bool = false
    var errorState: String = ""
    var needInstalled: [String: Bool] = [:]

    init() {}

    func checkInstalled() -> Bool {
        // Checks to see whether all dependencies have been met
        self.needInstalled.removeAll()
        // MariaDB
        // Check if MariaDB is installed
        self.isMariaDBInstalled = maria.isMariaDBInstalled()
        // If installed
        if self.isMariaDBInstalled {
            // Check if burst database exists
            self.isMariaDBReady = maria.isMariaDBBurstReady()
            // If burst database does not exist..
            if !self.isMariaDBReady {
                // Check if MariaDB has the default root pwd
                self.isMariaDBDefaultPassword = maria.isMariaDBPasswordSet()
                // If not, we got problems
                if !self.isMariaDBDefaultPassword {
                    self.errorState = "MariaDB Default password has been changed"
                // If so, we just need to create the burst db
                } else {
                    self.needInstalled["mariaBurst"] = true
                }
            }
        // if not install, install MariaDB
        } else {
            self.needInstalled["mariaDB"] = true
        }

        // Java
        self.isJavaInstalled = java.isJava8Installed()
        if !self.isJavaInstalled {
            self.needInstalled["java"] = true
        }

        // Wallet
        self.isWalletInstalled = wallet.isWalletInstalled()
        if !self.isWalletInstalled {
            self.needInstalled["wallet"] = true
        }

        return (self.isMariaDBInstalled && self.isMariaDBReady && self.isJavaInstalled && self.isWalletInstalled)
    }

    func runInstaller(missing: [String: Bool]) {
        // Runs install for unmet dependencies
        var tmp_missing = missing
        while tmp_missing.count > 0 {
            if tmp_missing["java"] ?? false {
                print("Installing Java")
                self.isJavaInstalled = java.installJava()
                tmp_missing.removeValue(forKey: "java")
            } else if tmp_missing["mariaDB"] ?? false {
                print("Installing MariaDB")
                self.isMariaDBInstalled = maria.installMariaDB()
                maria.waitForMariaDBInstallation()
                tmp_missing.removeValue(forKey: "mariaDB")
            } else if tmp_missing["mariaBurst"] ?? false {
                print("Creating Burst Database")
                self.isMariaDBReady = maria.createMariaDBDatabase()
                tmp_missing.removeValue(forKey: "mariaBurst")
            } else if tmp_missing["wallet"] ?? false {
                print("Installing Wallet")
                self.isWalletInstalled = wallet.installWallet()
                tmp_missing.removeValue(forKey: "wallet")
            }
            util.delay(count: 5, closure: {})
        }
    }
}

//
//  MinerHelper.swift
//  BurstXBundle
//
//  Created by Andrew Scott on 2/17/18.
//  Copyright © 2018 Drowned Coast. All rights reserved.
//

import Foundation
import SwiftyJSON

class MinerHelper {

    let swiftBash = SwiftBasher()

    // local vars
    var isInstalled: Bool = false

    // paths
    var pathInstaller: String = ""
    var pathInstalled: String = ""

    init() {
        let bundle = Bundle.main
        // set paths
        self.pathInstaller = bundle.path(forResource: "install_miner", ofType: "sh")!
        self.pathInstalled = bundle.path(forResource: "is_miner_installed", ofType: "sh")!
    }

    func isMinerInstalled() -> Bool {
        if swiftBash.bash(command: "sh", arguments: [self.pathInstalled]) == "1" {
            self.isInstalled = true
        }
        return self.isInstalled
    }

    func installMiner() {
        Logger.log(message: "Installing Miner", event: .info)
        let installOutput = swiftBash.bash(command: "sh", arguments: [self.pathInstaller])
        if installOutput.last == "1" {
            Logger.log(message: "Miner Installed Successfully", event: .info)
        } else {
            Logger.log(message: "Error installing Miner: " + installOutput, event: .error)
        }
    }

    func configureMiner(config: MinerRequest) {
        if let path = Bundle.main.path(forResource: "creepMiner/bin/mining", ofType: "conf") {
            do {
                Logger.log(message: "Reading from mining config at " + path, event: .info)
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                var jsonObj = try JSON(data: data)
                jsonObj["mining"]["urls"]["wallet"].stringValue = config.wallet
                jsonObj["mining"]["urls"]["miningInfo"].stringValue = config.miningInfo
                jsonObj["mining"]["urls"]["submission"].stringValue = config.submission
                jsonObj["mining"]["plots"] = JSON(config.plotFiles)
                jsonObj["mining"]["targetDeadline"].stringValue = config.targetDeadline
                Logger.log(message: "Effective mining config: " + String(describing: jsonObj), event: .info)
                let jsonRawData = try jsonObj.rawData()
                let fileUrl = URL(fileURLWithPath: path)
                try jsonRawData.write(to: fileUrl, options: .atomic)
                Logger.log(message: "Successfully updated mining config", event: .info)
            } catch {
                Logger.log(message: "Error reading or parsing mining.conf", event: .error)
            }
        } else {
            Logger.log(message: "Could not find mining.conf", event: .error)
        }
    }
    
    func startMining() {

    }
    
    func stopMining() {

    }

}

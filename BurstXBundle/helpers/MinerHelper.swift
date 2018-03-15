//
//  MinerHelper.swift
//  BurstXBundle
//
//  Created by Andrew Scott on 2/17/18.
//

import Foundation
import SwiftyJSON

class MinerHelper {

    let swiftBash = SwiftBasher()

    // local vars
    var isInstalled: Bool = false

    // paths
    var pathInstalled: String = ""
    var pathStart: String = ""
    var pathStop: String = ""

    init() {
        let bundle = Bundle.main
        // set paths
        self.pathInstalled = bundle.path(forResource: "is_miner_installed", ofType: "sh")!
        self.pathStart = bundle.path(forResource: "miner_start", ofType: "sh")!
        self.pathStop = bundle.path(forResource: "miner_stop", ofType: "sh")!
    }

    func isMinerInstalled() -> Bool {
        if swiftBash.bash(command: "sh", arguments: [self.pathInstalled]) == "1" {
            self.isInstalled = true
            Logger.log(message: "Miner is Installed", event: .debug)
        } else {
            Logger.log(message: "Miner not found: " + swiftBash.bash(command: "sh", arguments: [self.pathInstalled]), event: .warn)
        }
        return self.isInstalled
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
                Logger.log(message: "Effective mining config: " + String(describing: jsonObj), event: .debug)
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
        Logger.log(message: "Starting Miner...", event: .info)
        DispatchQueue.global(qos: .default).async {
            print(self.swiftBash.bash(command: "sh", arguments: [self.pathStart]))
        }
    }

    func stopMining() {
        Logger.log(message: "Stopping Miner...", event: .info)
        DispatchQueue.global(qos: .default).async {
            _ = self.swiftBash.bash(command: "sh", arguments: [self.pathStop])
        }
    }

    static func urlArrayToString(urls: [URL]) -> String {
        var returnString = ""
        for url in urls {
            returnString += url.path + ","
        }
        return returnString
    }

    static func stringToPlotArray(plots: String) -> [String] {
        let stringArray = plots.components(separatedBy: ",").flatMap { plot in
            return NSURL(fileURLWithPath: plot).path
        }
        return stringArray
    }

}

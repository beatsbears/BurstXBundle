//
//  PlotterHelper.swift
//  BurstXBundle
//
//  Created by Andrew Scott on 2/10/18.
//  Copyright © 2018 Drowned Coast. All rights reserved.
//

import Foundation

class PlotterHelper {

    let swiftBash = SwiftBasher()

    // local vars
    var isInstalled: Bool = false
    var maxCompileOption: Int = 0
    var maxMemory: Int = 0
    var maxThreads: Int = 0
    var maxCapacity: Int = 0

    // current plotting vars
    var currentPlottingLog: String = ""
    var currentPlottingFile: String = ""

    // Possible Plotter Status
    let STARTING = "Starting"
    let EXPANDING = "Expanding"
    let RUNNING = "Running"
    let COMPLETE = "Complete"

    // paths
    var pathInstaller: String = ""
    var pathInstalled: String = ""
    var pathCPUFeatures: String = ""
    var pathMemorySize: String = ""
    var pathCPUThreads: String = ""
    var pathOpenSpace: String = ""
    var pathMakePlot: String = ""
    var pathRunPlotCommand: String = ""
    var pathPlotStatus: String = ""

    init() {
        let bundle = Bundle.main
        // set paths
        self.pathInstaller = bundle.path(forResource: "plotter_install", ofType: "sh")!
        self.pathInstalled = bundle.path(forResource: "is_plotter_installed", ofType: "sh")!
        self.pathCPUFeatures = bundle.path(forResource: "cpu_features", ofType: "sh")!
        self.pathMemorySize = bundle.path(forResource: "system_memory", ofType: "sh")!
        self.pathCPUThreads = bundle.path(forResource: "cpu_threads", ofType: "sh")!
        self.pathOpenSpace = bundle.path(forResource: "directory_open_space", ofType: "sh")!
        self.pathMakePlot = bundle.path(forResource: "create_plot_command", ofType: "sh")!
        self.pathRunPlotCommand = bundle.path(forResource: "run_plot_command", ofType: "sh")!
        self.pathPlotStatus = bundle.path(forResource: "get_plot_status", ofType: "sh")!

        // set plotter max/defaults
        self.maxCompileOption = self.returnMaxCompileOption(featureList: self.getCPUFeatures())
        self.maxMemory = self.getMaxMemory()
        self.maxThreads = self.getMaxThreads()

        if !isPlotterInstalled() {
            if self.maxCompileOption == 2 {
                self.installPlotter(cpuMode: 1)
            } else {
                self.installPlotter(cpuMode: 0)
            }
        }
    }

    func isPlotterInstalled() -> Bool {
        if swiftBash.bash(command: "sh", arguments: [self.pathInstalled]) == "1" {
            self.isInstalled = true
        }
        return self.isInstalled
    }

    func installPlotter(cpuMode: Int) {
        Logger.log(message: "Installing Plotter", event: .info)
        let installOutput = swiftBash.bash(command: "sh", arguments: [self.pathInstaller, String(cpuMode)])
        if installOutput.last == "1" {
            Logger.log(message: "Plotter Installed Successfully", event: .info)
        } else {
            Logger.log(message: "Error installing Plotter: " + installOutput, event: .error)
        }
    }

    func getCPUFeatures() -> [String] {
        let featureList: [String] = swiftBash.bash(command: "sh", arguments: [self.pathCPUFeatures])
            .components(separatedBy: " ")
        return featureList
    }

    func returnMaxCompileOption(featureList: [String]) -> Int {
        if featureList.contains("AVX2.0") {
            return 2
        }
        if featureList.contains("SSE4.2") || featureList.contains("SSE4.1") {
            return 1
        }
        return 0
    }

    func getMaxMemory() -> Int {
        // if this fails, return 2, who has < 2 GB RAM?
        return Int(swiftBash.bash(command: "sh", arguments: [self.pathMemorySize])) ?? 2
    }

    func getMaxThreads() -> Int {
        // if this fails, use a single thread
        return Int(swiftBash.bash(command: "sh", arguments: [self.pathCPUThreads])) ?? 1
    }

    func getOpenSpace(path: String) -> Int {
        self.maxCapacity =  Int(swiftBash.bash(command: "sh", arguments: [self.pathOpenSpace, path])) ?? 0
        return self.maxCapacity
    }

    func plotFile(request: PlotterRequest) {

        let plotTime = String(NSDate().timeIntervalSince1970)

        // GB mem to stagger
        let finalStagger = String((Int(request.staggerSize.dropLast(3))! * 1048576) / 256)
        Logger.log(message: "Computed Stagger: " + finalStagger, event: .info)
        // GB space to nonces
        let finalNonces = String(Int(request.nonces.dropLast(3))! * 1024 * 4)
        Logger.log(message: "Computed Nonces: " + finalNonces, event: .info)

        // Call in background
        DispatchQueue.global(qos: .default).async {
            Logger.log(message: "Starting Plotting with arguments: "
                + request.address + " : "
                + request.path + " : "
                + request.startingNonce + " : "
                + finalNonces + " : "
                + finalStagger + " : "
                + request.threads + " : "
                + String(request.coreMode), event: .info)
            _ = self.swiftBash.bash(command: "sh", arguments: [self.pathMakePlot,
                                                               request.address,
                                                               request.path,
                                                               request.startingNonce,
                                                               finalNonces,
                                                               finalStagger,
                                                               request.threads,
                                                               String(request.coreMode),
                                                               plotTime])
            print(self.swiftBash.bash(command: "sh", arguments: [self.pathRunPlotCommand]))
        }

        self.currentPlottingLog = plotTime + ".log"
        self.currentPlottingFile = request.address + "_" + request.startingNonce + "_" + finalNonces + "_" + finalStagger
    }

    func getPlotterStatus() -> [String: String] {
        // returns {status: STATUS, pct: PERCENT_DONE, speed: SPEED}
        var status = "Initializing"
        var pct = "0"
        var speed = "0"
        let rawLogLine = swiftBash.bash(command: "sh", arguments: [self.pathPlotStatus, self.currentPlottingLog])
        if rawLogLine.count > 0 {
            var stripperLogLine = rawLogLine
            if rawLogLine.contains("\n") {
                stripperLogLine = rawLogLine.components(separatedBy: CharacterSet.newlines).last!
            }
            if stripperLogLine.range(of: "Resizing") != nil {
                // Don't log the huge resizing messages
                Logger.log(message: "Raw plotter status: " + stripperLogLine, event: .debug)
            }
            if stripperLogLine.range(of: "Percent done") != nil {
                let endIndex = stripperLogLine.range(of: "%")!.lowerBound
                pct = String(stripperLogLine[..<endIndex]).trimmingCharacters(in: .whitespacesAndNewlines)
                status = "Plotting"
                if let match = stripperLogLine.range(of: "(?<=done. )(.*)(?= nonces)", options: .regularExpression) {
                    speed = String(stripperLogLine[match])
                }
            } else if stripperLogLine.range(of: "Finished") != nil {
                status = "Finished"
                pct = "100"
            }
        }
        return ["status": status, "pct": pct, "speed": speed]
    }
}

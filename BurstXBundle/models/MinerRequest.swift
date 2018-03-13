//
//  MinerRequest.swift
//  BurstXBundle
//
//  Created by Andrew Scott on 2/24/18.
//

import Foundation

class MinerRequest {

    var miningInfo: String = ""
    var submission: String = ""
    var wallet: String = ""
    var targetDeadline: String = ""
    var plotFiles: [String] = []

    init(miningInfo: String, submission: String, wallet: String, targetDeadline: String, plotFiles: [String]) {
        self.miningInfo = miningInfo
        self.submission = submission
        self.wallet = wallet
        self.targetDeadline = targetDeadline
        self.plotFiles = plotFiles
    }
}

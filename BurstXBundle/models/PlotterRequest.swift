//
//  PlotterRequest.swift
//  BurstXBundle
//
//  Created by Andrew Scott on 2/17/18.
//

import Foundation

class PlotterRequest {

    var address: String = ""
    var path: String = ""
    var startingNonce: String = ""
    var nonces: String = ""
    var staggerSize: String = ""
    var threads: String = ""
    var coreMode: Int = 0

    init(address: String, path: String, startingNonce: String, nonces: String, staggerSize: String,
         threads: String, coreMode: Int) {
        self.address = address
        self.path = path
        self.startingNonce = startingNonce
        self.nonces = nonces
        self.staggerSize = staggerSize
        self.threads = threads
        self.coreMode = coreMode
    }
}

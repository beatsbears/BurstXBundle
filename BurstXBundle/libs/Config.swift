//
//  Config.swift
//  BurstXBundle
//
//  Created by Andrew Scott on 3/8/18.
//

import Foundation

class Config {

    let config: NSMutableDictionary
    let path: String
    init() {
        self.path = Bundle.main.path(forResource: "BurstXBundle", ofType: "plist")!
        self.config = NSMutableDictionary(contentsOfFile: self.path)!
    }

    func update(key: String, value: String) {
        Logger.log(message: "Config value " + key + ": " + read(key: key), event: .debug)
        Logger.log(message: "Updating config value " + key + " to be " + value, event: .debug)
        self.config.setObject(value, forKey: key as NSCopying)
        self.config.write(toFile: self.path, atomically: true)
    }

    func read(key: String) -> String {
        return String(describing: self.config.object(forKey: key)!)
    }
}

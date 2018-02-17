//
//  utils.swift
//  BurstXBundle
//
//  Created by Andrew Scott on 2/5/18.
//

import Foundation

class Util {

    let defaults = UserDefaults.standard

    init() {}

    func delay(count: Int, closure: @escaping () -> Void) {
        let when = DispatchTime.now() + Double(count)
        DispatchQueue.main.asyncAfter(deadline: when) {
            closure()
        }
    }

    func setDefault(key: String, value: Bool) {
        self.defaults.set(value, forKey: key)
    }

    func setDefault(key: String, value: AnyObject) {
        self.defaults.set(value, forKey: key)
    }

    func getDefault(key: String, type: Bool) -> Bool {
        return self.defaults.bool(forKey: key)
    }

    func getDefault(key: String) -> Any? {
        return self.defaults.object(forKey: key)
    }
}

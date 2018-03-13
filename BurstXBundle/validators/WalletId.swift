//
//  WalletId.swift
//  BurstXBundle
//
//  Created by Andrew Scott on 3/12/18.
//

import Foundation

class WalletId {
    // This is the friendly Burst Wallet Address (ex: BURST-MVYC-B6MZ-7W9B-D7PJ9)

    init() {}

    class func isValidId(walletId: String) -> Bool {
        let addressRegEx = "^BURST-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{5}$"

        return NSPredicate(format: "SELF MATCHES %@", addressRegEx).evaluate(with: walletId)
    }
}

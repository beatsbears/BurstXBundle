//
//  NumericWalletId.swift
//  BurstXBundle
//
//  Created by Andrew Scott on 3/12/18.
//

import Foundation

class NumericWalletId {
    // This is the numeric Burst Wallet Address (ex: 12953097211892854730)

    init() {}

    class func isValidId(walletId: String) -> Bool {
        let addressRegEx = "^[0-9]{20}$"

        return NSPredicate(format: "SELF MATCHES %@", addressRegEx).evaluate(with: walletId)
    }
}

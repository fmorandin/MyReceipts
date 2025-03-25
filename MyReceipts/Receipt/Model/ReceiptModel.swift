//
//  ReceiptModel.swift
//  MyReceipts
//
//  Created by Felipe Morandin on 23/03/2025.
//

import Foundation

final class ReceiptModel: Identifiable {

    let id: ObjectIdentifier
    var timestamp: String?
    var location: String?
    var totalAmount: String?

    init(id: ObjectIdentifier, timestamp: String?, location: String?, totalAmount: String?) {

        self.id = id
        self.timestamp = timestamp
        self.location = location
        self.totalAmount = totalAmount
    }
}

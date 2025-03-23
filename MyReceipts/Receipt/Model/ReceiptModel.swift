//
//  ReceiptModel.swift
//  MyReceipts
//
//  Created by Felipe Morandin on 23/03/2025.
//

import Foundation

struct ReceiptModel: Identifiable {

    let id: Int
    let timestamp: Date
    let currency: String
    let location: String
    let totalAmount: Double

    init(receipt: Receipt) {

        self.id = receipt.objectID.hashValue
        self.timestamp = receipt.timestamp ?? Date()
        self.currency = receipt.currency ?? "$"
        self.location = receipt.location ?? "--"
        self.totalAmount = receipt.totalAmount
    }
}

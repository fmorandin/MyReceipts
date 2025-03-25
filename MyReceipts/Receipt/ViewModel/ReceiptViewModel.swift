//
//  ReceiptListViewModel.swift
//  MyReceipts
//
//  Created by Felipe Morandin on 23/03/2025.
//

import Foundation
import os.log
import UIKit

final class ReceiptListViewModel: ObservableObject {

    // MARK: - Private Variables

    private let service: ReceiptServiceProtocol

    // MARK: - Public Variables

    @Published var receipts: [ReceiptModel] = []
    @Published var errorMessage: String?

    @Published var showScanner = false
    @Published var image = UIImage()

    // MARK: - Initialiser

    init(service: ReceiptServiceProtocol = ReceiptService()) {

        self.service = service
        fetchReceipts()
    }

    // MARK: - Public Methods

    func fetchReceipts() {
        do {
            if let fetchedReceipts = try service.fetchReceipts() {
                receipts = fetchedReceipts.map { ReceiptModel(receipt: $0) }
                errorMessage = nil
            } else {
                errorMessage = "Failed to load receipts. Please try again."
                receipts = []
            }
        } catch {
            errorMessage = "Error fetching receipts: \(error.localizedDescription)"
        }
    }


    func addReceipt(currency: String, location: String, totalAmount: Double, date: Date) {
        do {
            try service.saveReceipt(currency: currency, location: location, totalAmount: totalAmount, date: date)
            fetchReceipts()
        } catch {
            errorMessage = "Error saving receipt: \(error.localizedDescription)"
        }
    }

    func removeReceipt(_ receiptId: ObjectIdentifier) {

        do {
            guard let receipts = try service.fetchReceipts(),
                  let coreDataReceipt = receipts.first(where: { $0.id.hashValue == receiptId.hashValue }) else {
                errorMessage = "Receipt not found."
                return
            }
            
            try service.deleteReceipt(coreDataReceipt)
            fetchReceipts()
        } catch {
            errorMessage = "Error deleting receipt: \(error.localizedDescription)"
        }
    }
}

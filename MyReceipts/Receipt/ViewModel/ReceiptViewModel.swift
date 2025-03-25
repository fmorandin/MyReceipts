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
                receipts = fetchedReceipts.map { receipt in
                    return ReceiptModel(
                        id: receipt.id,
                        timestamp: receipt.timestamp,
                        location: receipt.location,
                        totalAmount: receipt.totalAmount)
                }
                errorMessage = nil
            } else {
                errorMessage = "Failed to load receipts. Please try again."
                receipts = []
            }
        } catch {
            errorMessage = "Error fetching receipts: \(error.localizedDescription)"
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

    func parseAndAddReceipt(_ items: [TextItem]) {

        guard let item = items.first else { return }

        let itemArray = item.text.split(separator: "\n").map { String($0) }

        print(itemArray)

        // Assuming that we will always have the venue in the first line of the scanned text
        let location = itemArray[0]
        let totalAmount: String = extractTotal(from: itemArray) ?? "0.00"
        let date: String = extractDate(from: itemArray) ?? "--"

        addReceipt(location: String(location), totalAmount: totalAmount, date: date)
    }

    func addReceipt(location: String, totalAmount: String, date: String) {

        do {
            try service.saveReceipt(location: location, totalAmount: totalAmount, date: date)
            fetchReceipts()
        } catch {
            errorMessage = "Error saving receipt: \(error.localizedDescription)"
        }
    }

    // MARK: - Private Methods

    private func extractDate(from items: [String]) -> String? {

        let datePattern = #"\b(\d{2}[/-]\d{2}[/-]\d{4}(?: \d{2}:\d{2}:\d{2})?)\b"#

        for item in items {
            if let match = item.range(of: datePattern, options: .regularExpression) {
                return String(item[match])
            }
        }
        return nil
    }

    private func extractTotal(from items: [String]) -> String? {

        let totalPattern = #"(?i)\bTotal(?:\s+\w+)*\s*(?:\([\w\s]+\))?\s*[:\-]?\s*([\d]+(?:[.,]\d{1,2})?)\b"#

        for item in items {
            if let match = item.range(of: totalPattern, options: .regularExpression) {
                let matchText = String(item[match]) // Convert Substring to String

                let numberPattern = #"[\d]+(?:[.,]\d{1,2})?"#
                if let numberMatch = matchText.range(of: numberPattern, options: .regularExpression) {
                    return String(matchText[numberMatch]) // Convert Substring to String
                }
            }
        }
        return nil
    }
}

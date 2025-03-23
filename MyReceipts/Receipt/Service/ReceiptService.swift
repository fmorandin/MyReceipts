//
//  ReceiptService.swift
//  MyReceipts
//
//  Created by Felipe Morandin on 23/03/2025.
//

import Foundation
import os.log

protocol ReceiptServiceProtocol {

    func fetchReceipts() throws -> [Receipt]?
    func saveReceipt(currency: String, location: String, totalAmount: Double, date: Date) throws
    func deleteReceipt(_ receipt: Receipt) throws
}

struct ReceiptService: ReceiptServiceProtocol {

    // MARK: - Private Variables

    private let repository: CoreDataRepository<Receipt>

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "br.com.felipemorandin.MyReceipts",
        category: NSStringFromClass(CoreDataRepository.self)
    )

    // MARK: - Initialiser

    init(repository: CoreDataRepository<Receipt> = CoreDataRepository()) {

        self.repository = repository
    }

    // MARK: - Public Methods

    func fetchReceipts() throws -> [Receipt]? {

        logger.info("Fetching receipts using CoreDataRepository")

        do {
            return try repository.fetchAll(
                sortDescriptors: [NSSortDescriptor(keyPath: \Receipt.timestamp, ascending: false)]
            )
        } catch {
            logger.error("Failed to fetch receipts: \(error.localizedDescription)")
            throw error
        }
    }

    func saveReceipt(currency: String, location: String, totalAmount: Double, date: Date) throws {

        do {
            try repository.create { receipt in
                receipt.timestamp = date
                receipt.currency = currency
                receipt.location = location
                receipt.totalAmount = totalAmount
            }
            logger.info("Successfully saved a receipt for \(totalAmount)\(currency) at \(location)")
        } catch {
            logger.error("Failed to save receipt: \(error.localizedDescription)")
            throw error
        }
    }

    func deleteReceipt(_ receipt: Receipt) throws {

        do {
            try repository.delete(receipt)
            logger.info("Deleted receipt at \(String(describing: receipt.timestamp))")
        } catch {
            logger.error("Failed to delete receipt: \(error.localizedDescription)")
            throw error
        }
    }
}

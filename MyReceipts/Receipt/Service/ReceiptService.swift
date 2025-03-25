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
    func saveReceipt(location: String, totalAmount: String, date: String) throws
    func deleteReceipt(_ receipt: Receipt) throws
}

struct ReceiptService: ReceiptServiceProtocol {

    // MARK: - Private Variables

    private let repository: CoreDataRepositoryProtocol

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "br.com.felipemorandin.MyReceipts",
        category: NSStringFromClass(CoreDataRepository.self)
    )

    // MARK: - Initialiser

    init(repository: CoreDataRepositoryProtocol = CoreDataRepository()) {

        self.repository = repository
    }

    // MARK: - Public Methods

    func fetchReceipts() throws -> [Receipt]? {

        logger.info("Fetching receipts using CoreDataRepository")

        do {
            let savedReceipts = try repository.fetchAll(sortDescriptors: nil)
            logger.info("Successfully fetched \(String(describing: savedReceipts?.count)) receipts")
            return savedReceipts
        } catch {
            logger.error("Failed to fetch receipts: \(error.localizedDescription)")
            throw error
        }
    }

    func saveReceipt(location: String, totalAmount: String, date: String) throws {

        do {
            try repository.create { receipt in

                receipt.timestamp = date
                receipt.location = location
                receipt.totalAmount = totalAmount
                logger.info("Saved receipt: \(receipt.location ?? "Unknown Location"), \(receipt.timestamp ?? "Unknown Date"), \(receipt.totalAmount ?? "Unknown Amount")")
            }
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

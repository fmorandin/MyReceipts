//
//  ReceiptServiceTests.swift
//  MyReceiptsTests
//
//  Created by Felipe Morandin on 20/03/2025.
//

import XCTest
@testable import MyReceipts

final class ReceiptServiceTests: XCTestCase {

    let service = ReceiptService(repository: MockCoreDataRepository())

    func testFetchReceipts_WhenNoReceipts_ReturnsEmptyArray() throws {
        let receipts = try service.fetchReceipts()
        XCTAssertTrue(receipts?.isEmpty ?? false, "Expected empty receipts list")
    }

    func testSaveReceipt_ShouldStoreReceiptCorrectly() throws {
        let date = Date()
        try service.saveReceipt(location: "New York", totalAmount: "100.0", date: "25/03/2025")

        let receipts = try service.fetchReceipts()
        XCTAssertEqual(receipts?.count, 1, "Expected one receipt to be stored")
    }

    func testDeleteReceipt_ShouldRemoveReceiptFromStorage() throws {
        let date = Date()
        try service.saveReceipt(location: "Lisbon", totalAmount: "50.0", date: "25/03/2025")

        var receipts = try service.fetchReceipts()
        XCTAssertEqual(receipts?.count, 1, "Expected one receipt stored before deletion")

        if let receiptToDelete = receipts?.first {
            try service.deleteReceipt(receiptToDelete)
        }

        receipts = try service.fetchReceipts()
        XCTAssertTrue(receipts?.isEmpty ?? false, "Expected no receipts after deletion")
    }
}

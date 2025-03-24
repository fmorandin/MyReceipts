//
//  ReceiptListViewModelTests.swift
//  MyReceiptsTests
//
//  Created by Felipe Morandin on 23/03/2025.
//

import XCTest
@testable import MyReceipts

final class ReceiptListViewModelTests: XCTestCase {

    var viewModel: ReceiptListViewModel!
    var mockService: ReceiptService!

    override func setUp() {
        super.setUp()
        let mockRepository = MockCoreDataRepository()
        mockService = ReceiptService(repository: mockRepository)
        viewModel = ReceiptListViewModel(service: mockService)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testFetchReceipts_InitiallyEmpty_ShouldLoadNoReceipts() {
        viewModel.fetchReceipts()
        XCTAssertTrue(viewModel.receipts.isEmpty, "Expected no receipts initially")
    }

    func testAddReceipt_ShouldAddReceiptToViewModel() {

        viewModel.addReceipt(currency: "GBP", location: "London", totalAmount: 75.0, date: Date())
        XCTAssertEqual(viewModel.receipts.count, 1, "Expected one receipt after adding")
    }

    func testRemoveReceipt_ShouldDeleteReceiptFromViewModel() {

        viewModel.addReceipt(currency: "USD", location: "New York", totalAmount: 120.0, date: Date())
        XCTAssertEqual(viewModel.receipts.count, 1, "Expected one receipt after adding")

        print(viewModel.receipts)
        viewModel.removeReceipt(viewModel.receipts.first!.id)

        XCTAssertTrue(viewModel.receipts.isEmpty, "Expected no receipts after removal")
    }

    func testFetchReceipts_WithStoredReceipts_ShouldLoadThem() {
        viewModel.addReceipt(currency: "EUR", location: "Paris", totalAmount: 90.0, date: Date())

        let newViewModel = ReceiptListViewModel(service: mockService)
        newViewModel.fetchReceipts()

        XCTAssertEqual(newViewModel.receipts.count, 1, "Expected receipts to persist across instances")
    }
}

//
//  MockCoreDataRepository.swift
//  MyReceiptsTests
//
//  Created by Felipe Morandin on 23/03/2025.
//

import CoreData
import Foundation
@testable import MyReceipts

final class MockCoreDataRepository: CoreDataRepositoryProtocol {

    private var receipts: [Receipt] = []

    func fetchAll<T: NSManagedObject>(sortDescriptors: [NSSortDescriptor]?) throws -> [T]? {
        receipts.sorted { $0.timestamp ?? Date() > $1.timestamp ?? Date() } as? [T]
    }

    func create<T: NSManagedObject>(_ configure: (T) -> Void) throws {
        let receipt = Receipt(context: PersistenceController.shared.container.viewContext)
        configure(receipt as! T)
        receipts.append(receipt)
    }

    func delete<T: NSManagedObject>(_ entity: T) throws {
        guard let receipt = entity as? Receipt else { return }
        receipts.removeAll { $0.timestamp == receipt.timestamp }
    }
}

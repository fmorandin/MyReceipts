//
//  CoreDataRepository.swift
//  MyReceipts
//
//  Created by Felipe Morandin on 23/03/2025.
//

import CoreData
import os.log

protocol CoreDataRepositoryProtocol {

    func fetchAll(sortDescriptors: [NSSortDescriptor]?) throws -> [Receipt]?
    func create(_ configure: (Receipt) -> Void) throws
    func delete(_ receipt: Receipt) throws
}

final class CoreDataRepository: CoreDataRepositoryProtocol {

    private let persistentContainer: NSPersistentContainer

    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "br.com.felipemorandin.MyReceipts",
        category: NSStringFromClass(CoreDataRepository.self)
    )

    init(container: NSPersistentContainer = PersistenceController.shared.container) {
        self.persistentContainer = container
    }

    func fetchAll(sortDescriptors: [NSSortDescriptor]? = nil) throws -> [Receipt]? {

        logger.info("Fetching all receipts from CoreData with sortDescriptors: \(String(describing: sortDescriptors))")

        let request = Receipt.fetchRequest()
        request.sortDescriptors = sortDescriptors

        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }

    func create(_ configure: (Receipt) -> Void) throws {

        logger.info("Creating receipt data in CoreData")

        let receipt = Receipt(context: context)
        configure(receipt)

        do {
            try saveContext()
            context.refresh(receipt, mergeChanges: true) // Refresh the context to make sure it has the latest changes
            logger.info("Successfully saved a receipt for \(receipt.totalAmount ?? "") at \(receipt.location ?? "") in \(receipt.timestamp ?? "")")
        } catch {
            throw error
        }
    }

    func delete(_ receipt: Receipt) throws {

        logger.info("Deleting receipt from CoreData")

        context.delete(receipt)

        do {
            try saveContext()
        } catch {
            throw error
        }
    }

    private func saveContext() throws {

        logger.info("Saving context in CoreData")

        if context.hasChanges {
            do {
                PersistenceController.shared.saveContext()
                try context.save()
            } catch {
                throw error
            }
        }
    }
}

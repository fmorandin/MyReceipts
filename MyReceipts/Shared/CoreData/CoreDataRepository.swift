//
//  CoreDataRepository.swift
//  MyReceipts
//
//  Created by Felipe Morandin on 23/03/2025.
//

import CoreData
import os.log

protocol CoreDataRepositoryProtocol {

    func fetchAll<T: NSManagedObject>(sortDescriptors: [NSSortDescriptor]?) throws -> [T]?
    func create<T: NSManagedObject>(_ configure: (T) -> Void) throws
    func delete<T: NSManagedObject>(_ object: T) throws
}

final class CoreDataRepository: CoreDataRepositoryProtocol {

    // MARK: - Private Variables

    private let persistentContainer: NSPersistentContainer

    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "br.com.felipemorandin.MyReceipts",
        category: NSStringFromClass(CoreDataRepository.self)
    )

    // MARK: - Initialiser

    init(container: NSPersistentContainer = PersistenceController.shared.container) {

        self.persistentContainer = container
    }

    // MARK: - Public Methods

    func fetchAll<T: NSManagedObject>(sortDescriptors: [NSSortDescriptor]? = nil) throws -> [T]? {

        logger.info("Fetching all data from CoreData with sortDescriptors: \(String(describing: sortDescriptors))")

        let request = T.fetchRequest()
        request.sortDescriptors = sortDescriptors

        do {
            return try context.fetch(request) as? [T]
        } catch {
            throw error
        }
    }

    func create<T: NSManagedObject>(_ configure: (T) -> Void) throws {

        logger.info("Creating data in CoreData")

        let entity = T(context: context)
        configure(entity)

        do {
            try saveContext()
        } catch {
            throw error
        }
    }

    func delete<T: NSManagedObject>(_ object: T) throws {

        logger.info("Deleting data in CoreData")

        context.delete(object)

        do {
            try saveContext()
        } catch {
            throw error
        }
    }

    func saveContext() throws {

        logger.info("Saving context in CoreData")

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw error
            }
        }
    }
}

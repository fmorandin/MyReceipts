//
//  Persistence.swift
//  MyReceipts
//
//  Created by Felipe Morandin on 20/03/2025.
//

import CoreData
import UIKit

final class PersistenceController {

    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {

        container = NSPersistentContainer(name: "MyReceipts")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            } else {
                print("Persistent store loaded: \(description)")
            }
        }
    }

    
    @objc func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("Context saved successfully")
            } catch {
                print("Failed to save context: \(error.localizedDescription)")
            }
        }
    }

    // TODO: Add this to App Delegate

    func saveContextOnAppTermination() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveContext), name: UIApplication.willTerminateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveContext), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
}

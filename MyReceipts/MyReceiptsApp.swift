//
//  MyReceiptsApp.swift
//  MyReceipts
//
//  Created by Felipe Morandin on 20/03/2025.
//

import SwiftUI

@main
struct MyReceiptsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

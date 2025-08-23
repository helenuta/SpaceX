//
//  SpaceXApp.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import SwiftUI

@main
struct SpaceXApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

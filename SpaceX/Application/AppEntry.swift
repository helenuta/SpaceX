//
//  AppEntry.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import SwiftUI

@main
struct SpaceXApp: App {
    @StateObject private var di = AppDIContainer.make()
    @StateObject private var coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            RootView(factory: di.factory)
                .environmentObject(coordinator)
                .environmentObject(di)
        }
    }
}

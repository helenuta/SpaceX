//
//  LaunchList.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import SwiftUI

struct LaunchList: View {
    @EnvironmentObject private var coordinator: AppCoordinator

    var body: some View {
        List {
            Section("Demo") {
                Button("Open arbitrary launch details") {
                    coordinator.openDetails(for: "demo-id-123")
                }
                Button("Open Favorites") {
                    coordinator.openFavorites()
                }
            }
        }
        .navigationTitle("Launches")
    }
}

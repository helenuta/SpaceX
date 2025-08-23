//
//  RootView.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject private var coordinator: AppCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            LandingView()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .launchesList:
                        LaunchList()
                    case .launchDetails(let id):
                        LaunchDetails(launchID: id)
                    case .favorites:
                        Favorites()
                    }
                }
        }
        .onAppear { coordinator.start() }
    }
}

private struct LandingView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("SpaceX")
                .font(.largeTitle).bold()
            Text("Bootstrapping…").foregroundColor(.secondary)
            ProgressView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

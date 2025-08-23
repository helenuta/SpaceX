//
//  LaunchDetails.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import SwiftUI

struct LaunchDetails: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    let launchID: String

    var body: some View {
        VStack(spacing: 12) {
            Text("Launch Details")
                .font(.title2).bold()
            Text("ID: \(launchID)").foregroundColor(.secondary)
            Button("Back") { coordinator.goBack() }
        }
        .padding()
        .navigationTitle("Details")
    }
}

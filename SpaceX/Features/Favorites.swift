//
//  Favorites.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import SwiftUI

struct Favorites: View {
    @EnvironmentObject private var coordinator: AppCoordinator

    var body: some View {
        VStack(spacing: 12) {
            Text("Favorites")
                .font(.title2).bold()
            Text("No favorites yet").foregroundColor(.secondary)
            Button("Back") { coordinator.goBack() }
        }
        .padding()
        .navigationTitle("Favorites")
    }
}

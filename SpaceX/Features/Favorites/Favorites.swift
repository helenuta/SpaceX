//
//  Favorites.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import SwiftUI

struct Favorites: View {
    @EnvironmentObject private var di: AppDIContainer
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var vm: FavoritesViewModel

    init() {
        // Temporary StateObject construction; later we can inject via a small factory.
        _vm = StateObject(wrappedValue: FavoritesViewModel(
            repo: AppDIContainer.make().launchesRepository,
            favorites: AppDIContainer.make().favoritesStore
        ))
    }
    var body: some View {
        FavoritesView(
            vm: vm,
            onOpenDetails: { coordinator.openDetails(for: $0) },
            onClearAll: { di.favoritesStore.removeAll() }
        )
        .navigationTitle("Favorites")
    }
}

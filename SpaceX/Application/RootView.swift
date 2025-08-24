//
//  RootView.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import SwiftUI
import Combine

struct RootView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var di: AppDIContainer
    @StateObject private var listVM: LaunchListViewModel
    
    init(factory: ViewModelFactory) {
            _listVM = StateObject(wrappedValue: factory.makeLaunchListViewModel())
        }
  
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            LaunchListView(vm: listVM)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .launchesList:
                        LaunchListView(vm: listVM)

                    case .launchDetails(let id):
                        LaunchDetailsView(launchID: id, factory: di.factory)
                            .navigationBarTitleDisplayMode(.inline)

                    case .favorites:
                        FavoritesView(
                            vm: di.factory.makeFavoritesViewModel(),
                            onOpenDetails: { coordinator.openDetails(for: $0) },
                            onClearAll: { di.favoritesStore.removeAll() }
                        )
                        .navigationTitle("Favorites")
                    }
                }
        }
    }
}

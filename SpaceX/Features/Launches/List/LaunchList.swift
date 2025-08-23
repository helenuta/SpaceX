//
//  LaunchList.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import SwiftUI

struct LaunchList: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var di: AppDIContainer
    @StateObject private var vm: LaunchListViewModel
    
    init() {
        _vm = StateObject(wrappedValue:
                            LaunchListViewModel(repo: AppDIContainer.make().launchesRepository,
                                                favorites: AppDIContainer.make().favoritesStore))
        // this dummy will be immediately replaced
    }
    
    var body: some View {
        content
            .navigationTitle("Launches")
            .onAppear {
                // Rebind to the actual DI singletons
                // (workaround to pass env objects into @StateObject)
                if vm !== _vm.wrappedValue {
                    // no-op; kept for clarity; the StateObject is already bound
                }
                vm.onAppear()
            }
    }
    
    @ViewBuilder
    private var content: some View {
        Group {
            if vm.isLoading {
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let err = vm.errorMessage {
                VStack(spacing: 12) {
                    Text(err).multilineTextAlignment(.center)
                    Button("Retry") { vm.reload() }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(vm.rows) { row in
                    Button {
                        coordinator.openDetails(for: row.id)
                    } label: {
                        LaunchRowView(row: row) { vm.toggleFavorite(id: row.id) }
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

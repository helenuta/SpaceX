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
            .toolbar {
                Button {
                    coordinator.openFavorites()
                } label: {
                    Image(systemName: "heart")
                }
            }
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
                    LaunchRowView(row: row) {
                           vm.toggleFavorite(id: row.id)
                       }
                       .contentShape(Rectangle())
                       .onTapGesture {                            
                           coordinator.openDetails(for: row.id)
                       }
                       .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                           Button {
                               vm.toggleFavorite(id: row.id)
                           } label: {
                               Label(row.isFavorite ? "Unfavorite" : "Favorite",
                                     systemImage: row.isFavorite ? "heart.slash" : "heart")
                           }
                           .tint(row.isFavorite ? .gray : .pink)
                       }
                }
                .listStyle(.plain)
            }
        }
    }
}

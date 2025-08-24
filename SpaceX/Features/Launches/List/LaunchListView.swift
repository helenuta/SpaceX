//
//  LaunchListView.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import SwiftUI

struct LaunchListView<VM: LaunchListViewModeling>: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @ObservedObject var vm: VM
    
    var body: some View {
        content
            .navigationTitle("Launches")
            .toolbar {
                Button {
                    coordinator.openFavorites()
                } label: {
                    Image(systemName: "heart.fill")
                }
            }
            .onAppear {
                vm.onAppear()
            }
    }
    
    @ViewBuilder
    private var content: some View {
        if vm.isLoading {
            StateView(kind: .loading(title: "Loading launches…"))
        } else if let err = vm.errorMessage {
            StateView(kind: .error(message: err) { vm.reload() })
        } else if vm.rows.isEmpty {
            StateView(kind: .empty(title: "No launches", subtitle: "Try again later", systemImage: "clock"))
        } else {
            list
        }
    }
    
    @ViewBuilder private var list: some View {
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

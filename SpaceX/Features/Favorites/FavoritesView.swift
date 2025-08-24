//
//  FavoritesView.swift
//  SpaceX
//
//  Created by Elena Anghel on 24.08.2025.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var vm: FavoritesViewModel
    let onOpenDetails: (String) -> Void
    let onClearAll: () -> Void

    var body: some View {
        Group {
            if vm.isLoading {
                StateView(kind: .loading(title: "Loading favorites…"))
            } else if let err = vm.errorMessage {
                StateView(kind: .error(message: err) { vm.reload() })
            } else if vm.rows.isEmpty {
                StateView(kind: .empty(title: "No favorites yet", subtitle: "Heart a launch to see it here", systemImage: "heart"))
            } else {
                list
            }
        }
        .toolbar {
            if !vm.rows.isEmpty { Button("Clear All") { onClearAll() } }
        }
        .onAppear { vm.onAppear() }
    }
    
    @ViewBuilder private var list: some View {
        List(vm.rows) { row in
            LaunchRowView(
                row: .init(id: row.id,
                           title: row.title,
                           subtitle: row.subtitle,
                           imageURL: row.imageURL,
                           isFavorite: true)
            ) {
                vm.removeFavorite(id: row.id)
            }
            .contentShape(Rectangle())
            .onTapGesture { onOpenDetails(row.id) }
            .swipeActions {
                Button(role: .destructive) {
                    vm.removeFavorite(id: row.id)
                } label: {
                    Label("Remove", systemImage: "trash")
                }
            }
        }
        .listStyle(.plain)
    }
}

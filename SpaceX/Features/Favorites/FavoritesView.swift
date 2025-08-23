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
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let err = vm.errorMessage {
                VStack(spacing: 12) {
                    Text(err).multilineTextAlignment(.center)
                    Button("Retry") { vm.reload() }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if vm.rows.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "heart")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)
                    Text("No favorites yet")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
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
        .toolbar {
            if !vm.rows.isEmpty {
                Button("Clear All") { onClearAll() }
            }
        }
        .onAppear {
            vm.onAppear()
        }
    }
}

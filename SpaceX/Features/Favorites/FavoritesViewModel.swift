//
//  FavoritesViewModel.swift
//  SpaceX
//
//  Created by Elena Anghel on 24.08.2025.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class FavoritesViewModel: ObservableObject {
    struct Row: Identifiable, Hashable {
        let id: String
        let title: String
        let subtitle: String
        let imageURL: URL?
        var isFavorite: Bool
    }

    @Published private(set) var rows: [Row] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let repo: LaunchesRepositoryType
    private let favorites: FavoritesStoring
    private var allLaunches: [Launch] = []
    private var cancellables = Set<AnyCancellable>()

    init(repo: LaunchesRepositoryType, favorites: FavoritesStoring) {
        self.repo = repo
        self.favorites = favorites
        bindFavorites()
    }

    func onAppear() {
        if allLaunches.isEmpty { load() }
        else { rebuildRows() }
    }

    func reload() { load() }

    func removeFavorite(id: String) { favorites.remove(id) }

    private func load() {
        isLoading = true; errorMessage = nil
        repo.fetchPastLaunches()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] c in
                self?.isLoading = false
                if case .failure(let err) = c { self?.errorMessage = err.localizedDescription }
            }, receiveValue: { [weak self] launches in
                self?.allLaunches = launches
                self?.rebuildRows()
            })
            .store(in: &cancellables)
    }

    private func rebuildRows() {
        let favs = favorites.ids
        let filtered = allLaunches.filter { favs.contains($0.id) }
        self.rows = filtered.map {
            Row(id: $0.id,
                title: $0.name,
                subtitle: AppDateFormatter.launchShort.string(from: $0.date),
                imageURL: $0.imageURL,
                isFavorite: true)
        }
    }

    private func bindFavorites() {
        favorites.publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] favs in
                
                guard let self else { return }
                if self.allLaunches.isEmpty, !favs.isEmpty {
                    // If we have favorites but no launches cached yet, fetch them.
                    self.load()
                } else {
                    self.rebuildRows()
                }
            }
            .store(in: &cancellables)
    }
}

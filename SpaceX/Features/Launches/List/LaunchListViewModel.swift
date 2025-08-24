//
//  LaunchListViewModel.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import Foundation
import Combine

@MainActor
final class LaunchListViewModel: ObservableObject {
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
    private var cancellables = Set<AnyCancellable>()

    init(repo: LaunchesRepositoryType, favorites: FavoritesStoring) {
        self.repo = repo
        self.favorites = favorites
        bindFavorites()
    }

    func onAppear() {
        guard rows.isEmpty else { return }
        load()
    }

    func reload() { load() }

    func toggleFavorite(id: String) {
        favorites.toggle(id)
    }

    private func load() {
        isLoading = true
        errorMessage = nil

        repo.fetchPastLaunches()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] c in
                self?.isLoading = false
                if case .failure(let err) = c { self?.errorMessage = err.localizedDescription }
            }, receiveValue: { [weak self] launches in
                guard let self else { return }
                let favs = self.favorites.ids
                self.rows = launches.map {
                    .init(
                        id: $0.id,
                        title: $0.name,
                        subtitle: AppDateFormatter.launchShort.string(from: $0.date),
                        imageURL: $0.imageURL,
                        isFavorite: favs.contains($0.id)
                    )
                }
            })
            .store(in: &cancellables)
    }

    private func bindFavorites() {
        favorites.publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] favs in
                guard let self else { return }
                self.rows = self.rows.map { row in
                    var r = row
                    r.isFavorite = favs.contains(row.id)
                    return r
                }
            }
            .store(in: &cancellables)
    }
}

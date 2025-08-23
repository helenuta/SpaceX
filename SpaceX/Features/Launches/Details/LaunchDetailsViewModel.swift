//
//  LaunchDetailsViewModel.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import Foundation
import Combine

final class LaunchDetailsViewModel: ObservableObject {
    // MARK: Inputs
    let launchID: String

    // MARK: Outputs (UI state)
    @Published private(set) var title: String = ""
    @Published private(set) var dateText: String = ""
    @Published private(set) var detailsText: String?
    @Published private(set) var imageURL: URL?
    @Published private(set) var youtubeURL: URL?
    @Published private(set) var wikipediaURL: URL?
    @Published private(set) var rocketName: String?
    @Published private(set) var payloadMassText: String?   // e.g., "4,820 kg"
    @Published private(set) var isFavorite: Bool = false
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?

    // MARK: Services
    private let repo: LaunchesRepository
    private let favorites: FavoritesStore
    private var cancellables = Set<AnyCancellable>()

    // Internal
    private var launch: Launch?

    init(launchID: String, repo: LaunchesRepository, favorites: FavoritesStore) {
        self.launchID = launchID
        self.repo = repo
        self.favorites = favorites
        bindFavorites()
    }

    func onAppear() {
        guard launch == nil else { return }
        load()
    }

    func toggleFavorite() { favorites.toggle(launchID) }

    // MARK: - Loading
    private func load() {
        isLoading = true
        errorMessage = nil

        // 1) Fetch the launch
        repo.fetchLaunch(id: launchID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] c in
                guard let self else { return }
                self.isLoading = false
                if case .failure(let err) = c { self.errorMessage = err.localizedDescription }
            }, receiveValue: { [weak self] launch in
                guard let self else { return }
                self.launch = launch
                self.title = launch.name
                self.dateText = AppDateFormatter.launchShort.string(from: launch.date)
                self.detailsText = launch.details
                self.imageURL = launch.imageURL
                self.youtubeURL = launch.youtubeURL
                self.wikipediaURL = launch.wikipediaURL
                self.isFavorite = self.favorites.isFavorite(launch.id)

                // 2) Lazy fetch rocket name
                if let rocketID = launch.rocketID {
                    self.repo.fetchRocket(id: rocketID)
                        .receive(on: DispatchQueue.main)
                        .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] rocket in
                            self?.rocketName = rocket.name
                        })
                        .store(in: &self.cancellables)
                }

                // 3) Lazy fetch payloads and compute total mass
                let ids = launch.payloadIDs
                guard !ids.isEmpty else { return }
                Publishers.MergeMany(ids.map(self.repo.fetchPayload(id:)))
                    .map { $0.massKg ?? 0 }
                    .collect()
                    .map { masses -> String? in
                        let total = masses.reduce(0, +)
                        guard total > 0 else { return nil }
                        let nf = NumberFormatter()
                        nf.numberStyle = .decimal
                        nf.maximumFractionDigits = 0
                        return "\(nf.string(from: NSNumber(value: total)) ?? "\(Int(total))") kg"
                    }
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] text in
                        self?.payloadMassText = text
                    })
                    .store(in: &self.cancellables)
            })
            .store(in: &cancellables)
    }

    private func bindFavorites() {
        favorites.publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] favs in
                guard let self else { return }
                self.isFavorite = favs.contains(self.launchID)
            }
            .store(in: &cancellables)
    }
}

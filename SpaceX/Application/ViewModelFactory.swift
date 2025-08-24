//
//  ViewModelFactory.swift
//  SpaceX
//
//  Created by Elena Anghel on 24.08.2025.
//

import Foundation

@MainActor
final class ViewModelFactory: ObservableObject {
    private let repo: LaunchesRepositoryType
    private let favorites: FavoritesStoring
    private var favoritesVM: FavoritesViewModel?
    
    init(repo: LaunchesRepositoryType, favorites: FavoritesStoring) {
        self.repo = repo
        self.favorites = favorites
    }
    
    func makeLaunchListViewModel() -> LaunchListViewModel {
        LaunchListViewModel(repo: repo, favorites: favorites)
    }
    
    func makeLaunchDetailsViewModel(launchID: String) -> LaunchDetailsViewModel {
        return LaunchDetailsViewModel(launchID: launchID, repo: repo, favorites: favorites)
    }
    
    func makeFavoritesViewModel() -> FavoritesViewModel {
        if let vm = favoritesVM { return vm }
        let vm = FavoritesViewModel(repo: repo, favorites: favorites)
        favoritesVM = vm
        return vm
    }
}

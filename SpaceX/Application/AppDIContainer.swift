//
//  AppDIContainer.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import Foundation

final class AppDIContainer: ObservableObject {
    let network: HTTPClient
    let imageLoader: ImageLoader
    let favoritesStore: FavoritesStoring
    let launchesRepository: LaunchesRepositoryType
    let factory: ViewModelFactory
    
    init(network: HTTPClient,
         imageLoader: ImageLoader,
         favoritesStore: FavoritesStoring,
         launchesRepository: LaunchesRepositoryType,
         factory: ViewModelFactory) {
        self.network = network
        self.imageLoader = imageLoader
        self.favoritesStore = favoritesStore
        self.launchesRepository = launchesRepository
        self.factory = factory
    }
    
    @MainActor static func make() -> AppDIContainer {
        let config = NetworkConfig(baseURL: URL(string: "https://api.spacexdata.com")!,
                                   defaultHeaders: ["Accept": "application/json"])
        let http = HTTPClient(configuration: config)
        let img = ImageLoader()
        let context = PersistenceController.shared.container.viewContext
        let fav = FavoritesStore(context: context)
        let repo = LaunchesRepository(network: http)
        let factory = ViewModelFactory(repo: repo, favorites: fav)
        
        return AppDIContainer(network: http,
                              imageLoader: img,
                              favoritesStore: fav,
                              launchesRepository: repo,
                              factory: factory)
    }
}

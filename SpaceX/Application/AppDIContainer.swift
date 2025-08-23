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
    let favoritesStore: FavoritesStore
    let launchesRepository: LaunchesRepository

    init(network: HTTPClient,
         imageLoader: ImageLoader,
         favoritesStore: FavoritesStore,
         launchesRepository: LaunchesRepository) {
        self.network = network
        self.imageLoader = imageLoader
        self.favoritesStore = favoritesStore
        self.launchesRepository = launchesRepository
    }

    static func make() -> AppDIContainer {
        let config = NetworkConfig(baseURL: URL(string: "https://api.spacexdata.com")!,
                                    defaultHeaders: ["Accept": "application/json"])
        let http = HTTPClient(configuration: config)
        let img = ImageLoader()
        let context = PersistenceController.shared.container.viewContext
        let fav = FavoritesStore(context: context)
        let repo = LaunchesRepository(network: http)
        return AppDIContainer(network: http,
                              imageLoader: img,
                              favoritesStore: fav,
                              launchesRepository: repo)
    }
}

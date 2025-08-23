//
//  AppCoordinator.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import Foundation
import Combine

final class AppCoordinator: ObservableObject {
    @Published var path: [Route] = []

    func start() {
        path = [.launchesList]
    }

    func openDetails(for launchID: String) {
        path.append(.launchDetails(id: launchID))
    }

    func openFavorites() {
        path.append(.favorites)
    }

    func goBack() {
        _ = path.popLast()
    }

    func resetToRoot() {
        path.removeAll()
    }
}

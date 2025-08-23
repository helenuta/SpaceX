//
//  FavoritesStore.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import Foundation
import Combine

final class FavoritesStore: ObservableObject {
    @Published private(set) var ids: Set<String> = []

    func isFavorite(_ id: String) -> Bool { ids.contains(id) }

    func toggle(_ id: String) {
        if ids.contains(id) { ids.remove(id) } else { ids.insert(id) }
    }

    var publisher: AnyPublisher<Set<String>, Never> {
        $ids.eraseToAnyPublisher()
    }
}

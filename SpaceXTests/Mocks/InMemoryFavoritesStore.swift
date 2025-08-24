//
//  InMemoryFavoritesStore.swift
//  SpaceXTests
//
//  Created by Elena Anghel on 24.08.2025.
//
import XCTest
import Combine
@testable import SpaceX

@MainActor
final class InMemoryFavoritesStore: FavoritesStoring {
    private let subject = CurrentValueSubject<Set<String>, Never>([])
    var ids: Set<String> { subject.value }
    var publisher: AnyPublisher<Set<String>, Never> { subject.eraseToAnyPublisher() }

    func isFavorite(_ id: String) -> Bool { subject.value.contains(id) }
    func toggle(_ id: String) { isFavorite(id) ? remove(id) : add(id) }
    func add(_ id: String) { subject.value.insert(id) }
    func remove(_ id: String) { subject.value.remove(id) }
    func removeAll() { subject.value.removeAll() }
}

@MainActor
final class FavoritesStoreTests: XCTestCase {
    func testTogglePublishes() {
        let store = InMemoryFavoritesStore()
        var snapshots: [Set<String>] = []
        let cancellable = store.publisher.sink { snapshots.append($0) }

        store.toggle("A")
        store.toggle("B")
        store.toggle("A")

        XCTAssertEqual(snapshots.last, ["B"])
        _ = cancellable
    }
}

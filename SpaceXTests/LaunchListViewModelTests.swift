import XCTest
import Combine
@testable import SpaceX

@MainActor
final class LaunchListViewModelTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    
    func testToggleFavoriteFlipsIcon() {
        
        let launch = Launch(id: "L1", name: "Demo", date: Date(),
                            details: nil, imageURL: nil, youtubeURL: nil,
                            wikipediaURL: nil, rocketID: nil, payloadIDs: [])
        let repo = StubLaunchesRepository(launches: [launch])
        let favs = InMemoryFavoritesStore()
        let vm = LaunchListViewModel(repo: repo, favorites: favs)
        
        let loaded = expectation(description: "rows loaded")
        vm.$rows
            .dropFirst()                 
            .filter { !$0.isEmpty }      // we want at least one row
            .first()                     // completes after the first match
            .sink { _ in loaded.fulfill() }
            .store(in: &cancellables)
        
        vm.onAppear()
        wait(for: [loaded], timeout: 1.0)
        
        XCTAssertEqual(vm.rows.first?.isFavorite, false)
        
        // Toggle and wait for the favorite flag to flip
        let toggled = expectation(description: "favorite toggled")
        vm.$rows
            .sink { rows in
                if rows.first?.isFavorite == true { toggled.fulfill() }
            }
            .store(in: &cancellables)
        
        vm.toggleFavorite(id: "L1")
        wait(for: [toggled], timeout: 1.0)
        XCTAssertEqual(vm.rows.first?.isFavorite, true)
    }
    
    func test_onAppear_setsError_whenRepositoryFails() {
        
        let repo = StubLaunchesRepository(
            forcedError: .transport(URLError(.notConnectedToInternet))
        )
        let favs = InMemoryFavoritesStore()
        let vm = LaunchListViewModel(repo: repo, favorites: favs)
        
        // Expect errorMessage to become non-nil at some point
        let errorSet = expectation(description: "error set")
        vm.$errorMessage
            .dropFirst()
            .first { $0 != nil }         // complete on first non-nil
            .sink { _ in errorSet.fulfill() }
            .store(in: &cancellables)
        
        vm.onAppear()
        
        wait(for: [errorSet], timeout: 1.0)
        XCTAssertTrue(vm.rows.isEmpty)
        XCTAssertFalse(vm.isLoading)
        XCTAssertNotNil(vm.errorMessage)
    }
}

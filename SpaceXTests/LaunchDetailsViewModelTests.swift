//
//  LaunchDetailsViewModelTests.swift
//  SpaceXTests
//
//  Created by Elena Anghel on 24.08.2025.
//
import XCTest
import Combine
@testable import SpaceX

@MainActor
final class LaunchDetailsViewModelTests: XCTestCase {

    func testLoadsRocketAndPayload() {
        let launch = Launch(id: "L1", name: "CRS-30", date: Date(),
                            details: "Resupply mission",
                            imageURL: nil, youtubeURL: nil, wikipediaURL: nil,
                            rocketID: "R1", payloadIDs: ["P1","P2"])
        let rocket = Rocket(id: "R1", name: "Falcon 9")
        let p1 = Payload(id: "P1", massKg: 1500)
        let p2 = Payload(id: "P2", massKg: 2000)

        let repo = StubLaunchesRepository(
            launches: [launch],
            rockets: ["R1": rocket],
            payloads: ["P1": p1, "P2": p2],
            launchByID: ["L1": launch]
        )

        let favorites = InMemoryFavoritesStore() 
        let vm = LaunchDetailsViewModel(launchID: "L1", repo: repo, favorites: favorites)

        vm.onAppear()
        let exp = expectation(description: "rocket & payload")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            XCTAssertEqual(vm.title, "CRS-30")
            XCTAssertEqual(vm.rocketName, "Falcon 9")
            XCTAssertEqual(vm.payloadMassText, "3,500 kg")
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
}

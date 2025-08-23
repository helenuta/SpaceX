//
//  LaunchesRepository.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import Foundation
import Combine

final class LaunchesRepository {
    private let network: HTTPClient
    init(network: HTTPClient) { self.network = network }

//    func fetchPastLaunches() -> AnyPublisher<[String], Never> {
//        Just(["demo-id-123", "demo-id-456"]).eraseToAnyPublisher()
//    }
    func debugFetchPastRaw() -> AnyPublisher<Data, NetworkError> {
        network.requestData(LaunchesAPI.pastLaunches())
    }
}

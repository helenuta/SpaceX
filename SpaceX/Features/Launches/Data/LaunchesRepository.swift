//
//  LaunchesRepository.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import Foundation
import Combine

final class LaunchesRepository {
    private let network: HTTPing
    init(network: HTTPing) { self.network = network }

    // Fetch all past launches, map to domain, sort by date desc
    func fetchPastLaunches() -> AnyPublisher<[Launch], NetworkError> {
        network.request([LaunchDTO].self, from: LaunchesAPI.pastLaunches())
            .map { $0.map(Launch.init(from:)).sorted(by: { $0.date > $1.date }) }
            .eraseToAnyPublisher()
    }

    func fetchRocket(id: String) -> AnyPublisher<Rocket, NetworkError> {
        network.request(RocketDTO.self, from: LaunchesAPI.rocket(id: id))
            .map(Rocket.init(from:))
            .eraseToAnyPublisher()
    }

    func fetchPayload(id: String) -> AnyPublisher<Payload, NetworkError> {
        network.request(PayloadDTO.self, from: LaunchesAPI.payload(id: id))
            .map(Payload.init(from:))
            .eraseToAnyPublisher()
    }
    
    func fetchLaunch(id: String) -> AnyPublisher<Launch, NetworkError> {
          network.request(LaunchesAPI.launch(id: id), decoder: JSONDecoder.iso8601Milliseconds)
              .map { (dto: LaunchDTO) in Launch(from: dto) }
              .eraseToAnyPublisher()
      }
}


private extension HTTPing {
    func request<T: Decodable>(_ type: T.Type, from endpoint: Endpoint) -> AnyPublisher<T, NetworkError> {
        request(endpoint, decoder: .iso8601Milliseconds)
    }
}

//
//  StubLaunchesRepository.swift
//  SpaceXTests
//
//  Created by Elena Anghel on 24.08.2025.
//

import Combine
@testable import SpaceX

final class StubLaunchesRepository: LaunchesRepositoryType {

    var launches: [Launch]
    var rockets: [String: Rocket]
    var payloads: [String: Payload]
    var launchByID: [String: Launch]
    /// Tto make every call fail for error paths
    var forcedError: NetworkError?

    init(
        launches: [Launch] = [],
        rockets: [String: Rocket] = [:],
        payloads: [String: Payload] = [:],
        launchByID: [String: Launch] = [:],
        forcedError: NetworkError? = nil
    ) {
        self.launches = launches
        self.rockets = rockets
        self.payloads = payloads
        self.launchByID = launchByID
        self.forcedError = forcedError
    }

    // MARK: - Helpers
    private func success<T>(_ value: T) -> AnyPublisher<T, NetworkError> {
        Just(value).setFailureType(to: NetworkError.self).eraseToAnyPublisher()
    }
    private func failure<T>(_ error: NetworkError = .requestFailed(404)) -> AnyPublisher<T, NetworkError> {
        Fail(error: error).eraseToAnyPublisher()
    }
    private func maybe<T>(_ value: T) -> AnyPublisher<T, NetworkError> {
        if let err = forcedError { return failure(err) }
        return success(value)
    }

    // MARK: - LaunchesRepositoryType
    func fetchPastLaunches() -> AnyPublisher<[Launch], NetworkError> {
        maybe(launches)
    }

    func fetchRocket(id: String) -> AnyPublisher<Rocket, NetworkError> {
        if let err = forcedError { return failure(err) }
        guard let rocket = rockets[id] else { return failure(.requestFailed(404)) }
        return success(rocket)
    }

    func fetchPayload(id: String) -> AnyPublisher<Payload, NetworkError> {
        if let err = forcedError { return failure(err) }
        guard let payload = payloads[id] else { return failure(.requestFailed(404)) }
        return success(payload)
    }

    func fetchLaunch(id: String) -> AnyPublisher<Launch, NetworkError> {
        if let err = forcedError { return failure(err) }
        if let launch = launchByID[id] ?? launches.first(where: { $0.id == id }) {
            return success(launch)
        }
        return failure(.requestFailed(404))
    }
}

//
//  NetworkConfig.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import Foundation
import Combine

struct NetworkConfig {
    let baseURL: URL
    var headers: [String: String] = [:]
}

enum NetworkError: Error {
    case badURL
    case requestFailed(Int)
    case decoding(Error)
    case transport(Error)
    case unknown
}

final class HTTPClient {
    private let config: NetworkConfig
    private let session: URLSession

    init(configuration: NetworkConfig,
         session: URLSession = .shared) {
        self.config = configuration
        self.session = session
    }

    func get(path: String, query: [URLQueryItem] = []) -> AnyPublisher<Data, NetworkError> {
        var components = URLComponents(url: config.baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        if !query.isEmpty { components?.queryItems = query }
        guard let url = components?.url else { return Fail(error: .badURL).eraseToAnyPublisher() }

        var request = URLRequest(url: url)
        config.headers.forEach { request.addValue($1, forHTTPHeaderField: $0) }

        return session.dataTaskPublisher(for: request)
            .mapError { NetworkError.transport($0) }
            .tryMap { output in
                if let http = output.response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
                    throw NetworkError.requestFailed(http.statusCode)
                }
                return output.data
            }
            .mapError { $0 as? NetworkError ?? .unknown }
            .eraseToAnyPublisher()
    }
}

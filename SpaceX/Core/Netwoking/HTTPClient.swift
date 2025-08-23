//
//  HTTPClient.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import Foundation
import Combine

protocol HTTPing {
    func request<T: Decodable>(_ endpoint: Endpoint,
                               decoder: JSONDecoder) -> AnyPublisher<T, NetworkError>

    func requestData(_ endpoint: Endpoint) -> AnyPublisher<Data, NetworkError>
}

final class HTTPClient: HTTPing {
    private let config: NetworkConfig
    private let session: URLSession

    init(configuration: NetworkConfig, session: URLSession? = nil) {
        self.config = configuration
        self.session = session ?? configuration.makeSession()
    }

    func request<T: Decodable>(_ endpoint: Endpoint,
                               decoder: JSONDecoder = .iso8601Milliseconds) -> AnyPublisher<T, NetworkError> {
        requestData(endpoint)
            .tryMap { data -> T in
                do {
                    return try decoder.decode(T.self, from: data)
                } catch {
                    throw NetworkError.decoding(error)
                }
            }
            .mapError { $0 as? NetworkError ?? .unknown }
            .eraseToAnyPublisher()
    }

    func requestData(_ endpoint: Endpoint) -> AnyPublisher<Data, NetworkError> {
        do {
            let req = try endpoint.urlRequest(baseURL: config.baseURL, defaultHeaders: config.defaultHeaders)

            return session.dataTaskPublisher(for: req)
                .mapError { NetworkError.transport($0) }
                .tryMap { output in
                    guard let http = output.response as? HTTPURLResponse else {
                        throw NetworkError.unknown
                    }
                    guard (200..<300).contains(http.statusCode) else {
                        throw NetworkError.requestFailed(http.statusCode)
                    }
        
                    guard !output.data.isEmpty else { throw NetworkError.emptyResponse }
                    
                    return output.data
                }
                .retry(1)
                .mapError { $0 as? NetworkError ?? .unknown }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error as? NetworkError ?? .unknown).eraseToAnyPublisher()
        }
    }
}

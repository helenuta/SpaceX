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
    var defaultHeaders: [String: String] = ["Accept": "application/json"]
    var timeout: TimeInterval = 30

    func makeSession() -> URLSession {
        let cfg = URLSessionConfiguration.default
        cfg.timeoutIntervalForRequest = timeout
        cfg.requestCachePolicy = .useProtocolCachePolicy
        return URLSession(configuration: cfg)
    }
}

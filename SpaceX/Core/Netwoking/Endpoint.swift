//
//  Endpoint.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import Foundation

enum HTTPMethod: String {
    case GET, POST, PUT, PATCH, DELETE
}

struct Endpoint {
    var path: String
    var method: HTTPMethod = .GET
    var query: [URLQueryItem] = []
    var headers: [String: String] = [:]
    var body: Data? = nil

    init(path: String,
         method: HTTPMethod = .GET,
         query: [URLQueryItem] = [],
         headers: [String: String] = [:],
         body: Data? = nil) {
        self.path = path
        self.method = method
        self.query = query
        self.headers = headers
        self.body = body
    }

    func urlRequest(baseURL: URL, defaultHeaders: [String: String]) throws -> URLRequest {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        if !query.isEmpty { components?.queryItems = query }
        guard let url = components?.url else { throw NetworkError.badURL }

        var req = URLRequest(url: url)
        req.httpMethod = method.rawValue
        defaultHeaders.merging(headers, uniquingKeysWith: { _, rhs in rhs }).forEach {
            req.addValue($1, forHTTPHeaderField: $0)
        }
        req.httpBody = body
        return req
    }
}

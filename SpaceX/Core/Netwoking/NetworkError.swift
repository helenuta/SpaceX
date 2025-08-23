//
//  NetworkError.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case badURL
    case requestFailed(Int)
    case decoding(Error)
    case transport(Error)
    case emptyResponse
    case unknown

    var errorDescription: String? {
        switch self {
        case .badURL: return "Invalid URL."
        case .requestFailed(let code): return "Request failed with status \(code)."
        case .decoding(let err): return "Failed to decode response: \(err.localizedDescription)"
        case .transport(let err): return "Network transport error: \(err.localizedDescription)"
        case .emptyResponse: return "Empty response."
        case .unknown: return "Unknown network error."
        }
    }
}

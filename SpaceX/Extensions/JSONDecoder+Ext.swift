//
//  JSONDecoder+Ext.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import Foundation

extension JSONDecoder {
    static let iso8601Milliseconds: JSONDecoder = {
        let dec = JSONDecoder()
        // SpaceX returns ISO8601 with fractional seconds, handle both
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        dec.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let str = try container.decode(String.self)
            if let d = iso.date(from: str) { return d }
            // Fallback without fractional seconds
            let isoNoMs = ISO8601DateFormatter()
            isoNoMs.formatOptions = [.withInternetDateTime]
            if let d = isoNoMs.date(from: str) { return d }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid ISO8601 date: \(str)")
        }
        return dec
    }()
}

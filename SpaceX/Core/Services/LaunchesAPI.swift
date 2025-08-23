//
//  LaunchesAPI.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import Foundation

enum LaunchesAPI {
    static func pastLaunches() -> Endpoint {
        Endpoint(path: "/v4/launches/past") // GET by default
    }

    static func rocket(id: String) -> Endpoint {
        Endpoint(path: "/v4/rockets/\(id)")
    }

    static func payload(id: String) -> Endpoint {
        Endpoint(path: "/v4/payloads/\(id)")
    }
}

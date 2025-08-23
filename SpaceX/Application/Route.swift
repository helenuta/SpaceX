//
//  Route.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import Foundation

enum Route: Hashable {
    case launchesList
    case launchDetails(id: String)
    case favorites
}

//
//  DomainModels.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import Foundation

struct Launch: Identifiable, Hashable {
    let id: String
    let name: String
    let date: Date
    let details: String?
    let imageURL: URL?
    let youtubeURL: URL?
    let wikipediaURL: URL?
    let rocketID: String?
    let payloadIDs: [String]
}

struct Rocket: Identifiable, Hashable {
    let id: String
    let name: String
}

struct Payload: Identifiable, Hashable {
    let id: String
    let massKg: Double?
}

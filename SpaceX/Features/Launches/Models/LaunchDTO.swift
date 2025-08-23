//
//  LaunchDTO.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import Foundation

struct LaunchDTO: Decodable {
    let id: String
    let name: String
    let dateUTC: Date
    let details: String?
    let links: LinksDTO?
    let rocket: String?
    let payloads: [String]?

    enum CodingKeys: String, CodingKey {
        case id, name, details, links, rocket, payloads
        case dateUTC = "date_utc"
    }
}

struct LinksDTO: Decodable {
    let patch: PatchDTO?
    let flickr: FlickrDTO?
    let webcast: URL?
    let wikipedia: URL?
}

struct PatchDTO: Decodable {
    let small: URL?
    let large: URL?
}

struct FlickrDTO: Decodable {
    let original: [URL]?
}

struct RocketDTO: Decodable {
    let id: String
    let name: String
}

struct PayloadDTO: Decodable {
    let id: String
    let massKg: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case massKg = "mass_kg"
    }
}

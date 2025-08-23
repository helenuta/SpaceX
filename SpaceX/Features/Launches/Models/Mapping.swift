//
//  Mapping.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import Foundation

extension Launch {
    init(from dto: LaunchDTO) {
        let patchLarge = dto.links?.patch?.large
        let flickrFirst = dto.links?.flickr?.original?.first

        self.init(
            id: dto.id,
            name: dto.name,
            date: dto.dateUTC,
            details: dto.details,
            imageURL: patchLarge ?? flickrFirst,
            youtubeURL: dto.links?.webcast,
            wikipediaURL: dto.links?.wikipedia,
            rocketID: dto.rocket,
            payloadIDs: dto.payloads ?? []
        )
    }
}

extension Rocket {
    init(from dto: RocketDTO) {
        self.init(id: dto.id, name: dto.name)
    }
}

extension Payload {
    init(from dto: PayloadDTO) {
        self.init(id: dto.id, massKg: dto.massKg)
    }
}

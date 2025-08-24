//
//  FavoriteRow.swift
//  SpaceX
//
//  Created by Elena Anghel on 24.08.2025.
//

import Foundation

struct FavoriteRow: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let imageURL: URL?
    var isFavorite: Bool
}

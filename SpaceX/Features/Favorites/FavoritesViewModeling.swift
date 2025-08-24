//
//  FavoritesViewModeling.swift
//  SpaceX
//
//  Created by Elena Anghel on 24.08.2025.
//

import Foundation
import Combine

@MainActor
protocol FavoritesViewModeling: ObservableObject {
    var rows: [FavoriteRow] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }

    func onAppear()
    func reload()
    func removeFavorite(id: String)
}

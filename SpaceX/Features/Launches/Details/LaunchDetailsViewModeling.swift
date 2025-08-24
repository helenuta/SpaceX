//
//  LaunchDetailsViewModeling.swift
//  SpaceX
//
//  Created by Elena Anghel on 24.08.2025.
//

import Foundation

@MainActor
protocol LaunchDetailsViewModeling: ObservableObject {
    var launchID: String { get }
    var title: String { get }
    var dateText: String { get }
    var detailsText: String? { get }
    var imageURL: URL? { get }
    var youtubeURL: URL? { get }
    var wikipediaURL: URL? { get }
    var rocketName: String? { get }
    var payloadMassText: String? { get }
    var isFavorite: Bool { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }

    func onAppear()
    func toggleFavorite()
}

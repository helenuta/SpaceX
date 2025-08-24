//
//  LaunchListViewModeling.swift
//  SpaceX
//
//  Created by Elena Anghel on 24.08.2025.
//

import Foundation

@MainActor
protocol LaunchListViewModeling: ObservableObject {
    var rows: [LaunchListRow] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }

    func onAppear()
    func reload()
    func toggleFavorite(id: String)
}

//
//  LaunchRowView.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import SwiftUI

struct LaunchRowView: View {
    let row: LaunchListViewModel.Row
    let onToggleFavorite: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: row.imageURL) { phase in
                switch phase {
                case .empty: ProgressView().frame(width: 56, height: 56)
                case .success(let image): image.resizable().scaledToFill()
                        .frame(width: 56, height: 56).clipped().cornerRadius(8)
                case .failure: Image(systemName: "photo").frame(width: 56, height: 56)
                @unknown default: EmptyView()
                }
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(row.title).font(.headline)
                Text(row.subtitle).font(.subheadline).foregroundColor(.secondary)
            }
            Spacer()
            Button(action: onToggleFavorite) {
                Image(systemName: row.isFavorite ? "heart.fill" : "heart")
            }
            .buttonStyle(.borderless)
        }
        .padding(.vertical, 4)
    }
}

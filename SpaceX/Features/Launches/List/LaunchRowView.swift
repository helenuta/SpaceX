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
            AsyncImageView(url: row.imageURL, cornerRadius: 8) {
                ProgressView().frame(width: 56, height: 56)
            } failure: {
                Image(systemName: "photo").frame(width: 56, height: 56)
            }
            .frame(width: 56, height: 56).clipped().cornerRadius(8)
            
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

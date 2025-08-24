//
//  StateView.swift
//  SpaceX
//
//  Created by Elena Anghel on 24.08.2025.
//

import SwiftUI

struct StateView: View {
    enum Kind {
        case loading(title: String? = nil)
        case empty(title: String, subtitle: String? = nil, systemImage: String = "tray")
        case error(message: String, retry: () -> Void)
    }

    let kind: Kind

    var body: some View {
        switch kind {
        case .loading(let title):
            VStack(spacing: 12) {
                ProgressView()
                if let title { Text(title).font(.subheadline).foregroundStyle(.secondary) }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .empty(let title, let subtitle, let symbol):
            VStack(spacing: 10) {
                Image(systemName: symbol).font(.system(size: 40)).foregroundStyle(.secondary)
                Text(title).font(.headline)
                if let subtitle { Text(subtitle).font(.subheadline).foregroundStyle(.secondary) }
            }
            .multilineTextAlignment(.center)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .error(let message, let retry):
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(.orange)
                Text("Something went wrong").font(.headline)
                Text(message).font(.subheadline).foregroundStyle(.secondary).multilineTextAlignment(.center)
                Button("Retry", action: retry).buttonStyle(.borderedProminent)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

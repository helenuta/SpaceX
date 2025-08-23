//
//  LaunchDetailsView.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import SwiftUI
import YouTubePlayerKit

struct LaunchDetailsView: View {
    @ObservedObject var vm: LaunchDetailsViewModel
    @State private var safariURL: URL?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let videoURL = vm.youtubeURL {
                    YouTubeKitPlayerView(url: videoURL)
                        .padding(.bottom, 8)
                } else if let url = vm.imageURL {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty: ZStack { Rectangle().fill(Color.secondary.opacity(0.1)); ProgressView() }
                        case .success(let image): image.resizable().scaledToFill()
                        case .failure: Image(systemName: "photo").resizable().scaledToFit().padding()
                        @unknown default: EmptyView()
                        }
                    }
                    .frame(height: 220)
                    .clipped()
                    .cornerRadius(12)
                }
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(vm.title).font(.title2).bold()
                        Text(vm.dateText).font(.subheadline).foregroundColor(.secondary)
                    }
                    Spacer()
                    Button {
                        vm.toggleFavorite()
                    } label: {
                        Image(systemName: vm.isFavorite ? "heart.fill" : "heart")
                            .font(.title3)
                    }
                    .buttonStyle(.borderless)
                }
                
                if let details = vm.detailsText, !details.isEmpty {
                    Text(details).font(.body)
                }
                
                if vm.rocketName != nil || vm.payloadMassText != nil {
                    VStack(alignment: .leading, spacing: 8) {
                        if let name = vm.rocketName {
                            Label(name, systemImage: "rocket")
                        }
                        if let mass = vm.payloadMassText {
                            Label("Payload total: \(mass)", systemImage: "scalemass")
                        }
                    }
                    .font(.subheadline)
                }
                
                if vm.youtubeURL != nil || vm.wikipediaURL != nil {
                    HStack {
                        if let y = vm.youtubeURL {
                            Button {
                                safariURL = y
                            } label: {
                                Label("Watch on YouTube", systemImage: "play.rectangle.fill")
                            }
                        }
                        if let w = vm.wikipediaURL {
                            Button {
                                safariURL = w
                            } label: {
                                Label("Wikipedia", systemImage: "book.fill")
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
        }
        .overlay {
            if vm.isLoading { ProgressView().scaleEffect(1.2) }
        }
        .alert("Error", isPresented: .constant(vm.errorMessage != nil)) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(vm.errorMessage ?? "")
        }
        .sheet(item: $safariURL, content: { url in SafariView(url: url) })
        .onAppear { vm.onAppear() }
    }
}

extension URL: Identifiable { public var id: String { absoluteString } }

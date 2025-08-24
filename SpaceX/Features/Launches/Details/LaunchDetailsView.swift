//
//  LaunchDetailsView.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import SwiftUI
import YouTubePlayerKit

struct LaunchDetailsView<VM: LaunchDetailsViewModeling>: View {
    @StateObject private var vm: VM
    @State private var safariURL: URL?
    
    init(launchID: String, factory: ViewModelFactory) where VM == LaunchDetailsViewModel {
        _vm = StateObject(wrappedValue: factory.makeLaunchDetailsViewModel(launchID: launchID))
    }
    /// TESTS/PREVIEWS: inject any mock VM that conforms to the protocol
    init(vm: VM) {
        _vm = StateObject(wrappedValue: vm)
    }
    var body: some View {
        Group {
            if vm.isLoading {
                StateView(kind: .loading(title: "Loading details…"))
            } else if let err = vm.errorMessage {
                StateView(kind: .error(message: err) {
                    vm.onAppear()
                })
            } else {
                content
            }
        }
        .navigationTitle(vm.title.isEmpty ? "Details" : vm.title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $safariURL) { url in
            SafariView(url: url)
        }
        .onAppear { vm.onAppear() }
    }
    
    @ViewBuilder
    private var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // Video or image
                if let videoURL = vm.youtubeURL {
                    YouTubeKitPlayerView(url: videoURL)
                        .padding(.bottom, 8)
                } else {
                    AsyncImageView(url: vm.imageURL, cornerRadius: 12) {
                        ZStack { Rectangle().fill(Color.secondary.opacity(0.1)); ProgressView() }
                    } failure: {
                        Image(systemName: "photo").resizable().scaledToFit().padding()
                    }
                    .padding(.bottom, 8)
                }
                
                // Title + date + favorite
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(vm.title).font(.title2).bold()
                        Text(vm.dateText).font(.subheadline).foregroundColor(.secondary)
                    }
                    Spacer()
                    Button { vm.toggleFavorite() } label: {
                        Image(systemName: vm.isFavorite ? "heart.fill" : "heart")
                            .font(.title3)
                    }
                    .buttonStyle(.borderless)
                }
                
                // Details
                if let details = vm.detailsText, !details.isEmpty {
                    Text(details).font(.body)
                }
                
                // Rocket / payload
                if vm.rocketName != nil || vm.payloadMassText != nil {
                    VStack(alignment: .leading, spacing: 8) {
                        if let name = vm.rocketName {
                            Text("Rocket name: \(name)")
                                .font(.headline)
                        }
                        if let mass = vm.payloadMassText {
                            Label("Payload total: \(mass)", systemImage: "scalemass")
                        }
                    }
                    .font(.subheadline)
                }
                
                // External links
                if vm.youtubeURL != nil || vm.wikipediaURL != nil {
                    HStack {
                        if let y = vm.youtubeURL {
                            Button { safariURL = y } label: {
                                Label("Watch on YouTube", systemImage: "play.rectangle.fill")
                            }
                        }
                        if let w = vm.wikipediaURL {
                            Button { safariURL = w } label: {
                                Label("Wikipedia", systemImage: "book.fill")
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
        }
    }
}

extension URL: Identifiable { public var id: String { absoluteString } }

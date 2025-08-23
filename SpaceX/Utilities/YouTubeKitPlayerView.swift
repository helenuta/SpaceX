//
//  YouTubeKitPlayerView.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import SwiftUI
import YouTubePlayerKit

struct YouTubeKitPlayerView: View {
    let videoURL: URL        // <- renamed (not `url`)
       @State private var player: YouTubePlayer

       init(url: URL) {
           self.videoURL = url
           _player = State(initialValue: YouTubePlayer(url: url))
       }

       var body: some View {
           YouTubePlayerView(player) { state in
               switch state {
               case .idle:  ProgressView()
               case .ready: EmptyView()
               case .error(let error):
                   ContentUnavailableView("Error",
                                          systemImage: "exclamationmark.triangle.fill",
                                          description: Text("YouTube player couldn't be loaded: \(error.localizedDescription)"))
               }
           }
           .aspectRatio(16/9, contentMode: .fit)
           .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
       }
}

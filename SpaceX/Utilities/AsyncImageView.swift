//
//  AsyncImageView.swift
//  SpaceX
//
//  Created by Elena Anghel on 24.08.2025.
//

import SwiftUI
import Combine

struct AsyncImageView<Placeholder: View, Failure: View>: View {
    let url: URL?
    var cornerRadius: CGFloat = 8
    var loader: ImageLoading = ImageLoader.shared
    var placeholder: () -> Placeholder
    var failure: () -> Failure

    @State private var image: UIImage?
    @State private var cancellable: AnyCancellable?

    init(
        url: URL?,
        cornerRadius: CGFloat = 8,
        loader: ImageLoading = ImageLoader.shared,
        @ViewBuilder placeholder: @escaping () -> Placeholder = { ProgressView() },
        @ViewBuilder failure: @escaping () -> Failure = { Image(systemName: "photo") }
    ) {
        self.url = url
        self.cornerRadius = cornerRadius
        self.loader = loader
        self.placeholder = placeholder
        self.failure = failure
    }

    var body: some View {
        Group {
            if let img = image {
                Image(uiImage: img).resizable().scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            } else {
                placeholder()
            }
        }
        .onAppear(perform: load)
        .onChange(of: url) {
            load()
        }
        .onDisappear { cancellable?.cancel() }
    }

    private func load() {
        cancellable?.cancel()
        guard let url else { image = nil; return }
        cancellable = loader.image(for: url)
            .receive(on: DispatchQueue.main)  
            .sink { img in image = img }
    }
}

//
//  ImageLoader.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import UIKit
import Combine

final class ImageLoader {
    private var cache = NSCache<NSURL, UIImage>()
    private var cancellables = Set<AnyCancellable>()

    func image(for url: URL) -> AnyPublisher<UIImage?, Never> {
        if let cached = cache.object(forKey: url as NSURL) {
            return Just(cached).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .catch { _ in Just(nil) }
            .handleEvents(receiveOutput: { [weak self] image in
                if let image { self?.cache.setObject(image, forKey: url as NSURL) }
            })
            .eraseToAnyPublisher()
    }
}

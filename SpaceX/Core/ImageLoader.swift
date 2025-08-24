//
//  ImageLoader.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import UIKit
import Combine

protocol ImageLoading {
    func image(for url: URL) -> AnyPublisher<UIImage?, Never>
    func clearMemory()
}

final class ImageLoader: ImageLoading {
    static let shared = ImageLoader()

    private let session: URLSession
    private let memory = NSCache<NSURL, UIImage>()
    private var inFlight = [URL: PassthroughSubject<UIImage?, Never>]()
    private let lock = NSLock()
    private var disposables = Set<AnyCancellable>() // keeps downloads alive

    init() {
        let cfg = URLSessionConfiguration.default
        cfg.requestCachePolicy = .useProtocolCachePolicy
        cfg.timeoutIntervalForRequest = 30
        cfg.timeoutIntervalForResource = 60
        cfg.urlCache = URLCache(
            memoryCapacity: 64 * 1024 * 1024,
            diskCapacity: 256 * 1024 * 1024,
            diskPath: "image-cache"
        )
        session = URLSession(configuration: cfg)

        memory.countLimit = 300
        memory.totalCostLimit = 64 * 1024 * 1024
    }

    func image(for url: URL) -> AnyPublisher<UIImage?, Never> {
        let ns = url as NSURL

        // 1) Memory cache
        if let img = memory.object(forKey: ns) {
            return Just(img).eraseToAnyPublisher()
        }

        // 2) Disk cache
        let req = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        if let cached = session.configuration.urlCache?.cachedResponse(for: req),
           let img = UIImage(data: cached.data) {
            memory.setObject(img, forKey: ns, cost: cached.data.count)
            return Just(img).eraseToAnyPublisher()
        }

        // 3) Coalesce in-flight
        lock.lock()
        if let subject = inFlight[url] {
            lock.unlock()
            return subject.eraseToAnyPublisher()
        }
        let subject = PassthroughSubject<UIImage?, Never>()
        inFlight[url] = subject
        lock.unlock()

        // 4) Download
        session.dataTaskPublisher(for: req)
            .map { data, response -> UIImage? in
                // Cache to disk if OK
                if let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) {
                    let cached = CachedURLResponse(response: response, data: data)
                    self.session.configuration.urlCache?.storeCachedResponse(cached, for: req)
                }
                let img = UIImage(data: data)
                if let img { self.memory.setObject(img, forKey: ns, cost: data.count) }
                return img
            }
            .replaceError(with: nil)
            .handleEvents(receiveCompletion: { _ in
                self.lock.lock(); self.inFlight[url] = nil; self.lock.unlock()
            }, receiveCancel: {
                self.lock.lock(); self.inFlight[url] = nil; self.lock.unlock()
            })
            .subscribe(subject)
            .store(in: &disposables)

        return subject.eraseToAnyPublisher()
    }

    func clearMemory() { memory.removeAllObjects() }
}


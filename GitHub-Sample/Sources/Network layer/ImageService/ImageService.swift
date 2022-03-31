//
//  ImageService.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 29.03.2022.
//

import UIKit

class ImagesService: ImageServiceProtocol {
    
    // MARK: - Internal Properties
    
    static let shared = ImagesService()
    
    // MARK: - Private Properties
    
    private let completionQueue: DispatchQueue
    private var runningOperations: [IndexPath: Operation] = [:]
    
    // MARK: - Init
    
    init(completionQueue: DispatchQueue = .main) {
        self.completionQueue = completionQueue
    }
    
    // MARK: - ImageServiceProtocol
    
    func downloadImage(url: URL,
                       indexPath: IndexPath,
                       completion: @escaping ItemClosure<UIImage?>) {
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            completion(UIImage(data: cachedResponse.data))
            return
        }
        
        let downloadingOperation = ImageOperation(urlToImage: url) { data, response in
            guard let image = UIImage(data: data) else { return }
            self.completionQueue.async {
                completion(image)
                self.imageToCache(data: data, response: response)
            }
        }
        downloadingOperation.start()
        self.runningOperations[indexPath] = downloadingOperation
    }
    
    func cancel(indexPath: IndexPath) {
        guard let operation = self.runningOperations[indexPath] else { return }
        operation.cancel()
    }
    
    private func imageToCache(data: Data, response: URLResponse) {
        guard let responseURL = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
    }
}



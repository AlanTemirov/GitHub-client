//
//  ImageOperation.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 30.03.2022.
//

import Foundation

final class ImageOperation: AsynchronousOperation {
    
    // MARK: - Private properties
    
    private var urlToImage: URL
    private let completion: ItemsClosure<Data,URLResponse>
    private var urlSessionDataTask: URLSessionDataTask?
    
    // MARK: - Init
    
    init(urlToImage: URL, completion: @escaping ItemsClosure<Data,URLResponse>) {
        self.urlToImage = urlToImage
        self.completion = completion
    }
    
    // MARK: - Overriden
    
    override func main() {
        self.urlSessionDataTask = URLSession.shared.dataTask(with: self.urlToImage) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            defer { self.state = .finished }
            guard !self.isCancelled else { return }
            
            guard error == nil else { return }
            guard let data = data, let response = response else { return }
            
            self.completion(data, response)
        }
        self.urlSessionDataTask?.resume()
    }
    
    override func cancel() {
        super.cancel()
        self.urlSessionDataTask?.cancel()
    }
}

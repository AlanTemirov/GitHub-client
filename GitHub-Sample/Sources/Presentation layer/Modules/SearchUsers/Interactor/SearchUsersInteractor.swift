//
//  SearchUsersInteractor.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 28.03.2022.
//

import UIKit

final class SearchUsersInteractor {
    
    // MARK: - Internal properties
    
    weak var output: SearchUsersInteractorOutput!
    
    // MARK: - Private properties
    
    private let gitHubService: GitHubServiceProtocol
    private let imageService: ImageServiceProtocol
    private var previousRequest: Cancellable?
    
    // MARK: - Init
    
    init(gitHubService: GitHubServiceProtocol, imageService: ImageServiceProtocol) {
        self.gitHubService = gitHubService
        self.imageService = imageService
    }
    
}

// MARK: - SearchUsersInteractorInput

extension SearchUsersInteractor: SearchUsersInteractorInput {
    
    func search(text: String, pageNumber: Int) {
        self.previousRequest?.cancel()
        
        guard text.isNotEmpty else {
            self.output.data(text: text, users: .success(.init(totalCount: 0, items: [])))
            return
        }
        
        self.previousRequest = self.gitHubService.users(query: text,
                                                        pageNumber: pageNumber,
                                                        sort: .bestMatch,
                                                        order: .descending) { [weak self] result in
            switch result {
            case .success(let response):
                self?.output.data(text: text, users: .success(response))
            case .failure(let error):
                self?.output.data(text: text, users: .failure(error))
            }
        }
    }
    
    func loadImage(url: URL, indexPath: IndexPath, completion: @escaping ItemClosure<UIImage?>) {
        self.imageService.downloadImage(url: url, indexPath: indexPath) { image in
            completion(image)
        }
    }
    
    func cancelDownloadingImage(at indexPath: IndexPath) {
        self.imageService.cancel(indexPath: indexPath)
    }
    
}

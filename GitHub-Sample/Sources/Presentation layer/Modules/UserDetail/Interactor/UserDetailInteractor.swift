//
//  UserDetailInteractor.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 31.03.2022.
//

import Foundation

final class UserDetailInteractor {
    
    // MARK: - Internal properties
    
    weak var output: UserDetailInteractorOutput!
    
    // MARK: - Private properties
    
    private let gitHubService: GitHubServiceProtocol
    
    // MARK: - Init
    
    init(gitHubService: GitHubServiceProtocol) {
        self.gitHubService = gitHubService
    }
    
}

// MARK: - UserDetailInteractorInput

extension UserDetailInteractor: UserDetailInteractorInput {
    
    func getUserInfo(userName: String) {
        self.gitHubService.user(userName: userName) { [weak self] result in
            switch result {
            case .success(let user):
                self?.output.data(user: .success(user))
            case .failure(let error):
                self?.output.data(user: .failure(error))
            }
        }
    }
    
}

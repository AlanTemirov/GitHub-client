//
//  UserDetailPresenter.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 31.03.2022.
//

import UIKit

final class UserDetailPresenter {
    
    // MARK: - Internal properties
    
    weak var view: UserDetailViewInput!
    var interactor: UserDetailInteractorInput!
    
    // MARK: - Private properties
    
    private var viewModel: UserDetailViewModel
    
    // MARK: - Init
    
    init(viewModel: UserDetailViewModel) {
        self.viewModel = viewModel
    }
    
}

// MARK: - UserDetailViewOutput

extension UserDetailPresenter: UserDetailViewOutput {
    
    var titleName: String { self.viewModel.login }
    
    var avatarImage: UIImage? { self.viewModel.avatarImage }
    
    func viewDidLoad() {
        self.view.changeState(.blank(viewModel: .loading))
        self.interactor.getUserInfo(userName: self.viewModel.login)
    }
    
}

// MARK: - UserDetailInteractorOutput

extension UserDetailPresenter: UserDetailInteractorOutput {
    
    func data(user: Result<GitHubSearchUserModel?, ServiceError>) {
        switch user {
            
        case let .success(user):
            guard let user = user else {
                self.view.changeState(.blank(viewModel: .unknown))
                return
            }
            
            let pairs: [UserDetailViewController.State.Pair] = [
                ("Описание", user.bio),
                ("Локация", user.location),
                ("Количество репозиториев", user.publicReposCount)
            ]
            self.view.changeState(.content(fields: pairs))
            
        case .failure(_):
            self.view.changeState(.blank(viewModel: .unknown))
        }
    }
    
}

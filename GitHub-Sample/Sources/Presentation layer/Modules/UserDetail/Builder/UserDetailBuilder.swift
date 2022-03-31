//
//  UserDetailBuilder.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 31.03.2022.
//

import UIKit

final class UserDetailBuilder {
    
    static func buildModule(viewModel: UserDetailViewModel) -> UIViewController {
        let viewController = UserDetailViewController()
        let presenter = UserDetailPresenter(viewModel: viewModel)
        let gitHubService = GitHubService()
        let interactor = UserDetailInteractor(gitHubService: gitHubService)
        
        interactor.output = presenter
        
        presenter.view = viewController
        presenter.interactor = interactor
        
        viewController.output = presenter
        
        return viewController
    }
    
}

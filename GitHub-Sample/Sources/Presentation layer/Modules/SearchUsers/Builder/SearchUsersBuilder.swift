//
//  SearchUsersBuilder.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 28.03.2022.
//

import UIKit

final class SearchUsersBuilder: BuilderModule {
    
    static func buildModule() -> UIViewController {
        let viewController = SearchUsersViewController()
        let router = SearchUsersRouter(viewController: viewController)
        let presenter = SearchUsersPresenter()
        let dataProvider = SearchUsersDataProvider()
        let gitHubService = GitHubService()
        let imageService = ImagesService()
        let interactor = SearchUsersInteractor(gitHubService: gitHubService,
                                               imageService: imageService)
                
        dataProvider.output = presenter
        
        interactor.output = presenter
        
        presenter.router = router
        presenter.view = viewController
        presenter.interactor = interactor
        
        viewController.output = presenter
        viewController.dataProvider = dataProvider
        
        return viewController
    }
    
}

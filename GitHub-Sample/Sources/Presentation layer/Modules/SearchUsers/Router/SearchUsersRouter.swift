//
//  SearchUsersRouter.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 28.03.2022.
//

import UIKit

final class SearchUsersRouter: BaseRouter, SearchUsersRouterInput {
    
    func showDetailUser(viewModel: UserDetailViewModel) {
        let viewController = UserDetailBuilder.buildModule(viewModel: viewModel)
        self.show(viewController: viewController)
    }
    
}

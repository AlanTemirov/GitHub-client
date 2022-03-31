//
//  RootRouter.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 28.03.2022.
//

import UIKit

final class RootRouter: BaseRouter {
    
    func setRootVC(on window: UIWindow) {
        let rootViewController = SearchUsersBuilder.buildModule()
        let viewController = BaseNavigationViewController(rootViewController: rootViewController)
        self.setRoot(viewController: viewController, on: window)
    }
    
}

//
//  BaseRouter.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 28.03.2022.
//

import UIKit

class BaseRouter {
    
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
}

extension BaseRouter {
    
    func setRoot(viewController: UIViewController, on window: UIWindow) {
        window.rootViewController = viewController
    }
    
    func show(viewController: UIViewController, animated: Bool = true) {
        guard let presenter = self.viewController else {
            return
        }
        
        presenter.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func presentModally(viewController: UIViewController, animated: Bool = true) {
        guard let presenter = self.viewController else {
            return
        }
        viewController.modalPresentationStyle = .fullScreen
        presenter.present(viewController, animated: animated)
    }
    
}

//
//  BaseNavigationViewController.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 28.03.2022.
//

import UIKit

class BaseNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupColors()
    }
    
    func setupColors() {
        self.overrideUserInterfaceStyle = .light
        self.navigationBar.prefersLargeTitles = true
        self.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.defaultColor]
        self.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.defaultColor]
        self.navigationBar.tintColor = .defaultColor
    }
    
}

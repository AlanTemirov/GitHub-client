//
//  ViewModelConfigurable.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 29.03.2022.
//

import UIKit

protocol ViewModelConfigurable {
    
    /// Сконфигурировать вью-модель.
    func configure(viewModel: ViewModel)
}

extension ViewModelConfigurable where Self == BlankView {
    
    func configure(viewModel: ViewModel) {
        guard let model = viewModel as? BlankModel else {
            return
        }
        
        if model.isLoading {
            [self.imageView, self.titleLabel, self.button].forEach { $0.isHidden = true }
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            [self.imageView, self.titleLabel, self.button].forEach { $0.isHidden = false }
            self.titleLabel.text = model.title
            self.imageView.image = UIImage(named: model.imageName)
            self.button.setTitle(model.buttonTitle, for: .normal)
            self.button.isHidden = (model.buttonTitle ?? "").isEmpty
        }
    }
    
}

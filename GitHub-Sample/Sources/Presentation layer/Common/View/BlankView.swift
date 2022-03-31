//
//  BlankView.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 31.03.2022.
//

import UIKit

class BlankView: UIView, ViewModelConfigurable {
    
    // MARK: - Internal properties
    
    var onButtonTapped: VoidClosure?
        
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    let elementsStackView = UIStackView()
    
    let titleLabel = UILabel()
    
    let imageView = UIImageView()
    
    let button = UIButton(type: .system)
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Private
    
    private func configureUI() {
        self.addElementsStackView()
        self.setupConstaints()
    }
    
    private func addElementsStackView() {
        self.addSubview(self.elementsStackView)
        self.elementsStackView.axis = .vertical
        self.elementsStackView.distribution = .fillProportionally
        self.elementsStackView.alignment = .center
        self.elementsStackView.spacing = 5.0
        [self.activityIndicator, self.imageView, self.titleLabel, self.button]
            .forEach(self.elementsStackView.addArrangedSubview)
        
        
        self.button.addTarget(self, action: #selector(self.handleBtnTapped),
                              for: .touchUpInside)
    }
    
    private func setupConstaints() {
        self.elementsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let centerX = self.elementsStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let centerY = self.elementsStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        self.addConstraints([centerX, centerY])
    }
    
    @objc private func handleBtnTapped() {
        self.onButtonTapped?()
    }
    
    // MARK: - ViewModelConfigurable
    
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

//
//  UserDetailViewController.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 31.03.2022.
//

import UIKit

final class UserDetailViewController: UIViewController {
    
    // MARK: - Internal properties
    
    enum State {
        
        typealias Pair = (key: String, value: String?)
        
        case blank(viewModel: BlankModel)
        
        case content(fields: [Pair])
    }
    
    var output: UserDetailViewOutput!
    
    // MARK: - Private properties
    
    private let avatarImageView = UIImageView()
    
    private let blankView = BlankView()
    
    private let elementsStackView = UIStackView()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.output.viewDidLoad()
    }
    
    // MARK: - Configure UI
    
    private func configureUI() {
        self.addSubviews()
        self.configureView()
        self.configureAvatarImageView()
        self.configureElementsStackView()
        self.setupConstraints()
    }
    
    private func addSubviews() {
        [self.avatarImageView, self.blankView, self.elementsStackView]
            .forEach(self.view.addSubview)
    }
    
    private func configureView() {
        self.title = self.output.titleName
        self.view.backgroundColor = .white
    }
    
    private func configureAvatarImageView() {
        self.avatarImageView.image = self.output.avatarImage
        self.avatarImageView.contentMode = .scaleToFill
        
    }
    
    private func configureElementsStackView() {
        self.elementsStackView.axis = .vertical
        self.elementsStackView.distribution = .fillProportionally
        self.elementsStackView.spacing = 10.0
    }
    
    private func setupConstraints() {
        self.setupAvatarImageViewConstraints()
        self.setupBlankViewConstraints()
        self.setupElementsStackViewConstraints()
    }
    
    private func setupAvatarImageViewConstraints() {
        self.avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = self.avatarImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        let leading = self.avatarImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16.0)
        let width = self.avatarImageView.widthAnchor.constraint(equalToConstant: 128.0)
        let height = self.avatarImageView.heightAnchor.constraint(equalToConstant: 128.0)
        
        self.view.addConstraints([top, leading, width, height])
    }
    
    private func setupBlankViewConstraints() {
        self.blankView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = self.blankView.topAnchor.constraint(equalTo: self.avatarImageView.bottomAnchor, constant: 20.0)
        let leading = self.blankView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        let trailing = self.blankView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        let bottom = self.blankView.bottomAnchor.constraint(greaterThanOrEqualTo: self.view.bottomAnchor)
        
        self.view.addConstraints([top, leading, trailing, bottom])
    }
    
    private func setupElementsStackViewConstraints() {
        self.elementsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = self.elementsStackView.topAnchor.constraint(equalTo: self.avatarImageView.bottomAnchor, constant: 20.0)
        let leading = self.elementsStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16.0)
        let trailing = self.elementsStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16.0)
        let bottom = self.view.safeAreaLayoutGuide.bottomAnchor.constraint(greaterThanOrEqualTo: self.elementsStackView.bottomAnchor)
        
        self.view.addConstraints([top, leading, trailing, bottom])
    }
    
}
 
// MARK: - UserDetailViewInput

extension UserDetailViewController: UserDetailViewInput {    
    
    func changeState(_ state: State) {
        switch state {
        case let .blank(viewModel):
            self.elementsStackView.isHidden = true
            self.blankView.configure(viewModel: viewModel)
            self.blankView.isHidden = false
        case let .content(fields):
            self.blankView.isHidden = true
            self.elementsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            for f in fields {
                guard let value = f.value, value.isNotEmpty else {
                    continue
                }
                let stackPair = UIStackView()
                stackPair.axis = .horizontal
                stackPair.distribution = .fillEqually
                stackPair.spacing = 5.0
                
                let keyLabel = UILabel()
                keyLabel.numberOfLines = 0
                keyLabel.font = .boldSystemFont(ofSize: 20.0)
                keyLabel.text = f.key
                
                let valueLabel = UILabel()
                valueLabel.numberOfLines = 0
                valueLabel.font = .systemFont(ofSize: 22.0)
                valueLabel.text = f.value
                
                [keyLabel, valueLabel].forEach(self.elementsStackView.addArrangedSubview)
            }
            self.elementsStackView.isHidden = false
        }
    }
    
}

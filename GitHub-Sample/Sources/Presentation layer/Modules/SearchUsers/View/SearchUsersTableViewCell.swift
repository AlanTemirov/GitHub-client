//
//  SearchUsersTableViewCell.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 28.03.2022.
//

import UIKit

final class SearchUsersTableViewCell: UITableViewCell {
    
    // MARK: - Internal Properties
    
    enum Configuration {
        
        case data
        
        case loading
    }
    
    // MARK: - Private Properties
    
    private var config = Configuration.loading
    
    private let userImageView = UIImageView()
    private let titleLabel = UILabel()
    
    private lazy var activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.userImageView.image = nil
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure(self.config)
        self.initialSetup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overriden
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.contentView.alpha = selected ? 0.5 : 1.0
    }
    
    // MARK: - Internal
    
    func configure(_ config: Configuration) {
        self.config = config
        self.configureSubviews(config: config)
        self.setupConstraints(config: config)
    }
    
    func setupImage(_ image: UIImage?) {
        self.userImageView.image = image
    }
    
    // MARK: - Private
    
    private func initialSetup() {
        self.overrideUserInterfaceStyle = .light
        
        self.userImageView.clipsToBounds = true
        self.userImageView.layer.cornerRadius = 25.0
        self.userImageView.backgroundColor = .lightGray
        
        self.titleLabel.numberOfLines = 1
    }
    
    private func configureSubviews(config: Configuration) {
        switch config {
        case .data:
            if self.activityIndicator.superview != nil {
                self.activityIndicator.removeFromSuperview()
            }
            [self.titleLabel, self.userImageView].forEach(self.contentView.addSubview)
        case .loading:
            [self.titleLabel, self.userImageView].forEach { $0.removeFromSuperview() }
            self.contentView.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
    }
    
    private func setupConstraints(config: Configuration) {
        switch config {
        case .data:
            self.setupAirportsImageViewConstraints()
            self.setupTitleLabelConstraints()
        case .loading:
            self.setupActivityIndicatorConstraints()
        }
        
    }
    
    private func setupAirportsImageViewConstraints() {
        self.userImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let centerY = self.userImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        let leading = self.userImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16.0)
        let height = self.userImageView.heightAnchor.constraint(equalToConstant: 50.0)
        let width = self.userImageView.widthAnchor.constraint(equalToConstant: 50.0)
        
        self.contentView.addConstraints([centerY, leading, height, width])
    }
    
    private func setupTitleLabelConstraints() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let centerY = self.titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        let leading = self.titleLabel.leadingAnchor.constraint(equalTo: self.userImageView.trailingAnchor, constant: 16.0)
        let trailing = self.contentView.trailingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor, constant: 16.0)
        
        self.contentView.addConstraints([centerY, leading, trailing])
    }
    
    private func setupActivityIndicatorConstraints() {
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        let centerX = self.activityIndicator.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        let centerY = self.activityIndicator.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        self.contentView.addConstraints([centerX, centerY])
    }
    
}

// MARK: - ViewModelConfigurable

extension SearchUsersTableViewCell: ViewModelConfigurable {
    
    func configure(viewModel: ViewModel) {
        guard let model = viewModel as? SearchUsersContentViewModel else {
            return
        }
        
        self.titleLabel.attributedText = .string(with: model.name,
                                                 highlight: model.searchText,
                                                 font: self.titleLabel.font ?? .systemFont(ofSize: 17.0),
                                                 color: .defaultColor,
                                                 highlightColor: .systemBlue)
    }
    
}

//
//  SearchUsersPresenter.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 28.03.2022.
//

import UIKit

final class SearchUsersPresenter {
    
    // MARK: - Internal properties
    
    weak var view: SearchUsersViewInput!
    var interactor: SearchUsersInteractorInput!
    var router: SearchUsersRouterInput!
    
    // MARK: - Private properties
    
    private var state: SearchUsersViewController.State = .blank(viewModel: .empty) {
        didSet {
            self.view.changeState(self.state)
        }
    }
    
    private var viewModels: [SearchUsersContentViewModel] = []
    
    /// Флаг, указывающий, все ли данные поиска были загружены. По дефолту `false`.
    private var isAllDataLoaded = false {
        didSet {
            self.shouldShowStubAtEnd = !self.isAllDataLoaded
        }
    }
    
    /// Флаг, указывающий, идёт ли сейчас запрос поиска. По дефолту `false`.
    private var isSearchActive = false
    
    /// Флаг, указывающий, нужно ли показывать стабы. По дефолту `false`.
    private var shouldShowStubAtEnd = false {
        didSet {
            guard self.shouldShowStubAtEnd != oldValue,
                  !self.shouldShowStubAtEnd else {
                      return
                  }
            self.view.removeStubCell()
        }
    }
    
    private let debouncer = Debouncer(delay: 0.7)
    private var searchQuery = ""
    private var currentPageNumber = 1
    private let outputPagesSize = 9
    
    // MARK: - Private
    
    private func loadUsers(q: String) {
        guard !self.isAllDataLoaded, !self.isSearchActive else {
            return
        }
        self.isSearchActive = true
        self.interactor.search(text: q,
                               pageNumber: self.currentPageNumber)
    }
    
}

// MARK: - SearchUsersViewOutput

extension SearchUsersPresenter: SearchUsersViewOutput {
    
    var titleName: String { "Users" }
    
    func viewDidLoad() {
        self.view.changeState(.blank(viewModel: .startSearch))
    }
    
    func didChangeSearchQuery(searchQuery: String) {
        guard searchQuery.isNotEmpty else {
            self.state = .blank(viewModel: .startSearch)
            return
        }
        
        self.debouncer.debounce { [weak self] in
            guard let self = self else { return }
            self.view.scrollToTop(animated: false)
            self.viewModels = []
            self.currentPageNumber = 1
            self.state = .blank(viewModel: .loading)
            self.isAllDataLoaded = false
            self.isSearchActive = false
            self.loadUsers(q: searchQuery)
        }
    }
    
    func didBeginEditing() {
        guard self.searchQuery.isEmpty else {
            return
        }
        self.view.changeState(.blank(viewModel: .startSearch))
    }
    
    func didCancelButtonClicked() {
        self.view.changeState(.blank(viewModel: .startSearch))
        self.searchQuery = ""
        self.viewModels = []
        self.view.refresh()
    }
    
    func didTapRetryButton() {
        self.view.changeState(.blank(viewModel: .loading))
        self.loadUsers(q: self.searchQuery)
    }
    
}

// MARK: - SearchUsersDataProviderOutput

extension SearchUsersPresenter: SearchUsersDataProviderOutput {
    
    var isShowingStubs: Bool {
        self.state == .blank(viewModel: .loading)
    }
    
    var itemsCount: Int {
        var itemsCount = self.viewModels.count
        if self.shouldShowStubAtEnd {
            itemsCount += 1
        }
        return itemsCount
    }
    
    func model(at index: Int) -> SearchUsersContentViewModel? {
        self.viewModels[safe: index]
    }
    
    func didSelectElement(at index: Int) {
        guard let model = self.viewModels[safe: index] else { return }
        let detailModel = UserDetailViewModel(avatarImage: model.image, login: model.name)
        self.router.showDetailUser(viewModel: detailModel)
    }
    
    func didScrollToEnd() {
        self.loadUsers(q: self.searchQuery)
    }
    
    func getImage(at indexPath: IndexPath, completion: @escaping ItemClosure<UIImage?>) {
        guard let imageURL = self.viewModels[safe: indexPath.row]?.imageURL else {
            return
        }
        self.interactor.loadImage(url: imageURL, indexPath: indexPath) { [weak self] image in
            guard let self = self,
            self.viewModels[safe: indexPath.row] != nil else { return }
            self.viewModels[indexPath.row].image = image
            completion(image)
        }
    }
    
    func cancelGettingImage(at indexPath: IndexPath) {
        self.interactor.cancelDownloadingImage(at: indexPath)
    }
    
}

// MARK: - SearchUsersInteractorOutput

extension SearchUsersPresenter: SearchUsersInteractorOutput {
    
    func data(text: String, users: Result<GitHubSearchUsersModel, ServiceError>) {
        self.isSearchActive = false
        self.searchQuery = text
        
        guard text.isNotEmpty else {
            self.viewModels = []
            self.view.changeState(.blank(viewModel: .startSearch))
            return
        }
        
        switch users {
        case let .success(users):
            self.currentPageNumber += 1
            
            let models = users.items.compactMap {
                SearchUsersContentViewModel(name: $0.login,
                                            imageURL: $0.avatarUrlValue,
                                            searchText: self.searchQuery)
            }
            self.viewModels += models
            self.isAllDataLoaded = users.totalCount <= max(0, self.viewModels.count)
            
            if self.viewModels.isNotEmpty {
                self.state = .content
                self.view.refresh()
            } else {
                self.view.changeState(.blank(viewModel: .empty))
            }
        case .failure(_):
            self.viewModels = []
            self.view.changeState(.blank(viewModel: .unknown))
        }
    }
    
}

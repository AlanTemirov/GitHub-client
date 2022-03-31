//
//  SearchUsersViewController.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 28.03.2022.
//

import UIKit

final class SearchUsersViewController: BaseViewController {
    
    // MARK: - Internal properties
    
    enum State: Equatable {
        
        case blank(viewModel: BlankModel)
        
        case content
    }
    
    var output: (SearchUsersViewOutput & SearchUsersDataProviderOutput)!
    
    var dataProvider: SearchUsersDataProvider!
    
    // MARK: - Private properties
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let tableView = UITableView()
    
    private let blankView = BlankView()
    
    private var bottomKeyboard: NSLayoutConstraint!
    
    override var bindBottomToKeyboardFrame: NSLayoutConstraint? {
        self.bottomKeyboard
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        
        self.output.viewDidLoad()
    }
    
    deinit {
        self.unbindFromKeyboardNotifications()
    }
    
    // MARK: - Configure UI
    
    private func configureUI() {
        self.addSubviews()
        self.configureView()
        self.configureTableView()
        self.configureBlankView()
        self.configureSearchController()
        self.bindToKeyboardNotifications()
        self.setupConstraints()
    }
    
    private func configureView() {
        self.title = self.output.titleName
        self.view.backgroundColor = .white
    }
    
    private func addSubviews() {
        [self.tableView, self.blankView]
            .forEach(self.view.addSubview)
    }
    
    private func configureTableView() {
        self.tableView.isHidden = true
        self.tableView.backgroundColor = .white
        self.tableView.delegate = self.dataProvider
        self.tableView.dataSource = self.dataProvider
        self.tableView.prefetchDataSource = self.dataProvider
        self.tableView.tableFooterView = .init()
        self.tableView.tableHeaderView = .init()
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.register(cellType: SearchUsersTableViewCell.self)
    }
    
    private func configureBlankView() {
        self.blankView.onButtonTapped = { [weak self] in
            self?.output.didTapRetryButton()
        }
    }
    
    private func configureSearchController() {
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.navigationItem.searchController = self.searchController
    }
    
    private func setupConstraints() {
        self.setupTableViewConstraints()
        self.setupBlankViewConstraints()
    }
    
    private func setupTableViewConstraints() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor)
        let leading = self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        let trailing = self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        let bottom = self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        
        self.view.addConstraints([top, leading, trailing, bottom])
    }
    
    private func setupBlankViewConstraints() {
        self.blankView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = self.blankView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        let leading = self.blankView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        let trailing = self.blankView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        let bottom = self.view.bottomAnchor.constraint(equalTo: self.blankView.bottomAnchor)
        
        self.bottomKeyboard = bottom
        
        self.view.addConstraints([top, leading, trailing, bottom])
    }
}

// MARK: - UISearchControllerDelegate & UISearchBarDelegate

extension SearchUsersViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.output.didChangeSearchQuery(searchQuery: searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.output.didBeginEditing()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.output.didCancelButtonClicked()
    }
        
}

// MARK: - SearchUsersViewInput

extension SearchUsersViewController: SearchUsersViewInput {
    
    func refresh() {
        self.tableView.reloadData()
    }
    
    func reloadRow(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        if self.tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false {
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        }
    }
    
    func removeStubCell() {
        let dataSourceItemsCount = self.output.itemsCount
        guard dataSourceItemsCount > 0 else { return }
        let tableItemsCount = self.tableView.numberOfRows(inSection: 0)
        if dataSourceItemsCount < tableItemsCount {
            let indexPaths = (dataSourceItemsCount..<tableItemsCount).map {
                IndexPath(item: $0, section: 0)
            }
            self.tableView.deleteRows(at: indexPaths, with: .fade)
        }
    }
    
    
    func changeState(_ state: State) {
        switch state {
        case let .blank(model):
            self.tableView.isHidden = true
            self.blankView.configure(viewModel: model)
            self.blankView.isHidden = false
        case .content:
            self.blankView.isHidden = true
            self.tableView.isHidden = false
        }
    }
    
    func scrollToTop(animated: Bool) {
        self.tableView.scrollToBegin(animated: animated)
    }
    
}

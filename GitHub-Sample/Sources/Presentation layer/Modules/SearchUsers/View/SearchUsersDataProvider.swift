//
//  SearchUsersDataProvider.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 28.03.2022.
//

import UIKit

final class SearchUsersDataProvider: NSObject {
    
    // MARK: - Internal properties
    
    var output: SearchUsersDataProviderOutput!
    
    // MARK: - Private properties
    
    private enum Section: CaseIterable {
        case users
    }
    
    private let rowHeight: CGFloat = 100.0
    private let numberOfItemsFromEndToStartLoadOfNextPage = 3
    private let stubsCount = 1
    
    // MARK: - Private
    
    private func configureCell(_ dequeuedCell: UITableViewCell, at indexPath: IndexPath) {
        guard let cell = dequeuedCell as? SearchUsersTableViewCell else {
            return
        }
        guard let model = self.output.model(at: indexPath.row) else {
            cell.configure(.loading)
            return
        }
        
        self.output.getImage(at: indexPath) { [weak cell] image in
            cell?.setupImage(image)
        }
        cell.configure(.data)
        cell.configure(viewModel: model)
    }
    
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension SearchUsersDataProvider: UITableViewDelegate & UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.output.itemsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: SearchUsersTableViewCell.defaultReuseId,
                                                         for: indexPath)
        
        self.configureCell(dequeuedCell, at: indexPath)
        
        // На случай, если не отработает пагинация через префетчинг
        let count = self.output.itemsCount
        if !self.output.isShowingStubs,
           indexPath.row > count - self.numberOfItemsFromEndToStartLoadOfNextPage {
            self.output.didScrollToEnd()
        }
        return dequeuedCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.output.didSelectElement(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.output.cancelGettingImage(at: indexPath)
    }
    
}

// MARK: - UITableViewDataSourcePrefetching

extension SearchUsersDataProvider: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard !self.output.isShowingStubs,
              let indexPath = indexPaths.last else {
                  return
              }
        
        let count = self.output.itemsCount
        if indexPath.row > count - self.numberOfItemsFromEndToStartLoadOfNextPage {
            self.output.didScrollToEnd()
        }
    }
    
}

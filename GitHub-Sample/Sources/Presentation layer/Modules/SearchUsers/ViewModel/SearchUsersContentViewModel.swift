//
//  SearchUsersContentViewModel.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 29.03.2022.
//

import UIKit

struct SearchUsersContentViewModel: ViewModel, Equatable {
    
    let name: String
    
    let imageURL: URL?
    
    var image: UIImage?
    
    let searchText: String
}

//
//  GitHubSearchUserModel.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 30.03.2022.
//

import Foundation

struct GitHubSearchUserModel: Decodable {
    
    let bio: String?
    
    let location: String?

    let publicRepos: Int?
    
    var publicReposCount: String? {
        guard let publicRepos = self.publicRepos else {
            return nil
        }
        return String(publicRepos)
    }
    
    private enum CodingKeys: String, CodingKey {
        case bio
        case location
        case publicRepos = "public_repos"
    }
    
}

//
//  GitHubSearchUsersModel.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 28.03.2022.
//

import Foundation

struct GitHubSearchUsersModel: Decodable {
    
    let totalCount: Int
    
    let items: [Items]
    
    private enum CodingKeys: String, CodingKey {
        case items
        case totalCount = "total_count"
    }
    
    struct Items: Decodable {
        
        let login: String
        
        let avatarURL: String?
        
        var avatarUrlValue: URL? {
            guard let url = self.avatarURL else { return nil }
            return URL(string: url)
        }
        
        private enum CodingKeys: String, CodingKey {
            case login
            case avatarURL = "avatar_url"
        }
    }
    
}

//
//  GitHubSearchParams.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 28.03.2022.
//

import Foundation

enum GitHubSearchParams {
    
    /// Параметры сортировки
    ///
    /// - stars: По звездам
    /// - forks: По forks
    /// - bestMatch: По лучшему совпадению
    enum Sort: String {
        case stars = "stars"
        case forks = "forks"
        case bestMatch = "best-match"
    }
    
    /// Параметры порядка выдачи
    ///
    /// - ascending: По возрастанию
    /// - descending: По убыванию
    enum Order: String {
        case ascending = "asc"
        case descending = "desc"
    }
    
}

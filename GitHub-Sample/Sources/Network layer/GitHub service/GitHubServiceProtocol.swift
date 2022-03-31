//
//  GitHubServiceProtocol.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 28.03.2022.
//

import Foundation

protocol GitHubServiceProtocol {
    
    /// Получить список пользователей.
    /// - Parameters:
    ///   - query: Поисковая строка.
    ///   - pageNumber: Страница со списком пользователей.
    ///   - sort: Правила сортировки.
    ///   - order: Приоритет выдачи.
    ///   - completion: Замыкание с результатом выполненного запроса.
    @discardableResult
    func users(query: String,
               pageNumber: Int,
               sort: GitHubSearchParams.Sort,
               order: GitHubSearchParams.Order,
               completion: @escaping ItemClosure<Result<GitHubSearchUsersModel, ServiceError>>) -> Cancellable?
    
    /// Получить информацию о пользователе.
    /// - Parameters:
    ///   - userName: Имя пользователя.
    ///   - completion: Замыкание с результатом выполненного запроса.
    func user(userName: String, completion: @escaping ItemClosure<Result<GitHubSearchUserModel?, ServiceError>>)
}

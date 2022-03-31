//
//  UserDetailProtocols.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 31.03.2022.
//

import UIKit

protocol UserDetailViewInput: AnyObject {
    
    /// Изменить состояние вью контроллера.
    /// - Parameter state: Состояние вью контроллера.
    func changeState(_ state: UserDetailViewController.State)
}

protocol UserDetailViewOutput: AnyObject {
    
    /// Название модуля, отображаемое в навигейшн баре.
    var titleName: String { get }
    
    /// Изображение аватара.
    var avatarImage: UIImage? { get }
    
    /// Сообщает, что вью была загружена.
    func viewDidLoad()
}

protocol UserDetailInteractorInput {
    
    /// Получить данные о пользователе.
    /// - Parameter userName: Имя пользователя.
    func getUserInfo(userName: String)
}

protocol UserDetailInteractorOutput: AnyObject {
    
    /// Данные пользователя.
    ///  - Parameter user: Результат с опциональной моделью и ошибкой.
    func data(user: Result<GitHubSearchUserModel?, ServiceError>)
}

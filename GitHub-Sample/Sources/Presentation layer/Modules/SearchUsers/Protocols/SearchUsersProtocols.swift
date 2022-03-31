//
//  SearchUsersProtocols.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 28.03.2022.
//

import UIKit

protocol SearchUsersViewInput: AnyObject {
    
    /// Изменить состояние вью контроллера.
    /// - Parameter state: Состояние вью контроллера.
    func changeState(_ state: SearchUsersViewController.State)
    
    /// Перезагрузить таблицу.
    func refresh()
    
    /// Перезагрузить элемент по заданному индекс.
    /// - Parameter index: Заданный индекс.
    func reloadRow(at index: Int)
    
    /// Удалить ячейку стаба, которая отвечает за индикацию загрузки.
    func removeStubCell()
    
    /// Проскролить таблицу на самый верх.
    /// - Parameter animated: `true` - с анимацией, `false` - без анимации.
    func scrollToTop(animated: Bool)
}

protocol SearchUsersViewOutput: AnyObject {
    
    /// Название модуля, отображаемое в навигейшн баре.
    var titleName: String { get }
    
    /// Сообщает, что вью была загружена.
    func viewDidLoad()
    
    /// Сообщает, что изменился поисковый запрос.
    /// - Parameter searchQuery: Новый текст поискового запроса.
    func didChangeSearchQuery(searchQuery: String)
    
    /// Сообщает, что было начато редактирование поискового запроса.
    func didBeginEditing()
    
    /// Сообщает, что была нажата кнопка `Отмена`.
    func didCancelButtonClicked()
    
    /// Сообщает, что была нажата кнопка `Обновить`.
    func didTapRetryButton()
}

protocol SearchUsersDataProviderOutput {
    
    /// Состояние отображение стабов.
    var isShowingStubs: Bool { get }
    
    /// Кол-во элементов доступных для отображения.
    var itemsCount: Int { get }
    
    /// Запросить вью-модель, на основе которого будет возвращена её конфигурация.
    /// - Parameter index: Индекс ячейки.
    func model(at index: Int) -> SearchUsersContentViewModel?
    
    /// Сообщает, что был нажат элемент по указанному индексу.
    /// - Parameter index: Индекс ячейки.
    func didSelectElement(at index: Int)
    
    /// Сообщает, что вью была проскроллена до конца.
    func didScrollToEnd()
    
    /// Получить изображение.
    /// - Parameters:
    ///   - indexPath: Индекс-путь ячейки.
    ///   - completion: Замыкание с опциональным изображением.
    func getImage(at indexPath: IndexPath, completion: @escaping ItemClosure<UIImage?>)
    
    /// Отменить получение изображения.
    /// - Parameter indexPath: Индекс-путь ячейки.
    func cancelGettingImage(at indexPath: IndexPath)
}

protocol SearchUsersRouterInput: AnyObject {
    
    /// Показать экран детального пользователя.
    /// - Parameter viewModel: Вью-модель.
    func showDetailUser(viewModel: UserDetailViewModel)
}

// MARK: - Interactor

protocol SearchUsersInteractorInput: AnyObject {
    
    /// Найти пользователей.
    /// - Parameters:
    ///   - text: Текст запроса.
    ///   - pageNumber: Номер страницы.
    func search(text: String, pageNumber: Int)
    
    /// Загрузить изображение.
    /// - Parameters:
    ///   - url: указанный `URL` для скачивания.
    ///   - indexPath: Указанный индекс-путь для сохранения операций.
    ///   - completion: Замыкание с опциональной картинкой, загруженной из сети.
    func loadImage(url: URL, indexPath: IndexPath, completion: @escaping ItemClosure<UIImage?>)
    
    /// Отменить скачивание изображения по указанному индекс-пути.
    /// - Parameter indexPath: Указанный индекс-путь для отмены операции.
    func cancelDownloadingImage(at indexPath: IndexPath)
}

protocol SearchUsersInteractorOutput: AnyObject {
    
    /// Данные поиска.
    /// - Parameters:
    ///   - text: Текст запроса.
    ///   - users: Результат с моделью пользователей и ошибкой.
    func data(text: String, users: Result<GitHubSearchUsersModel, ServiceError>)
}

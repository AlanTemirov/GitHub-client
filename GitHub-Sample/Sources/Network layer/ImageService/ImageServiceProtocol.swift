//
//  ImageServiceProtocol.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 29.03.2022.
//

import UIKit

protocol ImageServiceProtocol {
    
    /// Скачать изображение по указанному `URL`.
    /// - Parameters:
    ///   - url: указанный `URL` для скачивания.
    ///   - indexPath: Указанный индекс-путь для сохранения операций.
    ///   - completion: Замыкание с опциональной картинкой, загруженной из сети.
    func downloadImage(url: URL,
                       indexPath: IndexPath,
                       completion: @escaping ItemClosure<UIImage?>)
    
    /// Отменить скачивание изображения по указанному индекс-пути.
    /// - Parameter indexPath: Указанный индекс-путь для отмены операции.
    func cancel(indexPath: IndexPath)
}

//
//  Debouncer.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 28.03.2022.
//

import Foundation

/// Главная цель данного объекта ограничить количество запросов.
/// Запрос не срабатывает немедленно, а ожидает указанный период времени перед запуском запроса.
final class Debouncer {
    
    // MARK: - Private properties
    
    /// Замыкание, которое выполнится после ожидания указанного периода времени.
    private var onDebounce: VoidClosure?
    private let delay: TimeInterval
    private let callQueue: DispatchQueue
    private var debounceWorkItem: DispatchWorkItem?
    private let workQueue = DispatchQueue(label: "ru.Debouncer.workQueue")
    
    // MARK: - Init
    
    /// Проинициализировать объект.
    /// - Parameters:
    ///   - delay: Задержка перед запуском запроса.
    ///   - queue: Очередь, на которой будет получен результат. По дефолту `main`.
    init(delay: TimeInterval,
         on queue: DispatchQueue = .main) {
        self.delay = delay
        self.callQueue = queue
    }
    
    // MARK: - Internal
    
    /// Функция, которая заставляет выполнение ждать определенное время, прежде чем снова запуститься.
    /// Работа ведется асинхронно.
    /// - Parameter onDebounce: Замыкание, которое будет выполнено после ожидания указанного периода времени.
    func debounce(_ onDebounce: @escaping VoidClosure) {
        self.workQueue.async { [weak self] in
            guard let self = self else { return }
            
            self.onDebounce = onDebounce
            self.debounceWorkItem?.cancel()
            
            let workItem = DispatchWorkItem { [weak self] in
                guard let self = self
                        , let onDebounce = self.onDebounce else { return }
                
                self.callQueue.async { onDebounce() }
            }
            self.debounceWorkItem = workItem
            self.workQueue.asyncAfter(deadline: .now() + self.delay, execute: workItem)
        }
    }
    
}

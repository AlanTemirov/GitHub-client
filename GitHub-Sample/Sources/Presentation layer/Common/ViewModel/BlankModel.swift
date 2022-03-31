//
//  BlankModel.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 29.03.2022.
//

import Foundation

struct BlankModel: ViewModel, Equatable {
    
    let title: String
    
    let imageName: String
    
    let buttonTitle: String?
    
    let isLoading: Bool
    
    // MARK: - Static
    
    static var empty: BlankModel {
        .init(title: "Ничего не нашлось",
              imageName: "nothingFound",
              buttonTitle: nil,
              isLoading: false)
    }
    
    static var unknown: BlankModel {
        .init(title: "Ошибка. Попробуйте ещё раз",
              imageName: "reload",
              buttonTitle: "Повторить",
              isLoading: false)
    }
    
    static var startSearch: BlankModel {
        .init(title: "Начните поиск",
              imageName: "search",
              buttonTitle: nil,
              isLoading: false)
    }
    
    static var loading: BlankModel {
        .init(title: "",
              imageName: "",
              buttonTitle: nil,
              isLoading: true)
    }
}

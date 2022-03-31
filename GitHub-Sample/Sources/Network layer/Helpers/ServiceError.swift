//
//  ServiceError.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 28.03.2022.
//

import Foundation

enum ServiceError: Error {
    case unknown
    case parsing
    case connection
    case combineURL
    case httpError(code: Int)
}

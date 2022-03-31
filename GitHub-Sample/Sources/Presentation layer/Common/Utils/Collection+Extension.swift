//
//  Collection+Extension.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 28.03.2022.
//

import Foundation

extension Collection {
    
    subscript(safe index: Index) -> Element? {
        (self.startIndex..<self.endIndex) ~= index ? self[index] : nil
    }
    
    var isNotEmpty: Bool {
        !self.isEmpty
    }
    
}

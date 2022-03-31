//
//  UITableView+Extension.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 28.03.2022.
//

import UIKit

extension UITableView {
    
    func register(cellType: UITableViewCell.Type) {
        self.registerCell(cellType, reuseIdentifier: cellType.defaultReuseId)
    }
    
    func registerCell(_ viewType: AnyClass, reuseIdentifier: String? = nil, nibName: String? = nil) {
        let sourceBundle = Bundle(for: viewType)
        let reuseIdentifier = reuseIdentifier ?? String(describing: viewType)
        let nibName = nibName ?? reuseIdentifier
        
        if sourceBundle.path(forResource: reuseIdentifier, ofType: "nib") != nil {
            let nib = UINib(nibName: nibName, bundle: sourceBundle)
            self.register(nib, forCellReuseIdentifier: reuseIdentifier)
        } else {
            self.register(viewType, forCellReuseIdentifier: reuseIdentifier)
        }
    }
    
    func dequeueReusableCell(cellType: UITableViewCell.Type, for indexPath: IndexPath) -> UITableViewCell {
        return self.dequeueReusableCell(withIdentifier: cellType.defaultReuseId, for: indexPath)
    }
    
    func scrollToBegin(animated: Bool = false) {
        self.setContentOffset(CGPoint(x: 0.0, y: -self.adjustedContentInset.top), animated: animated)
    }
    
}

extension UITableViewCell {
    
    static var defaultReuseId: String {
        return String(describing: self)
    }
    
}

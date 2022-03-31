//
//  NSAttributedString+Extension.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 30.03.2022.
//

import UIKit

extension NSAttributedString {
    
    class func string(with string: String,
                      highlight: String,
                      font: UIFont,
                      color: UIColor,
                      highlightColor: UIColor,
                      highlightFont: UIFont? = nil,
                      alignment: NSTextAlignment = .left,
                      caseSensitive: Bool = false) -> NSAttributedString {
        
        let highlightFont = highlightFont ?? font
        let totalRange = NSRange(location: 0, length: string.count)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        
        let attributedString = NSMutableAttributedString(string: string)
        
        attributedString.addAttribute(
            .foregroundColor,
            value: color,
            range: totalRange)
        
        attributedString.addAttribute(
            .font,
            value: font,
            range: totalRange)
        
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: totalRange)
        
        let inputString = caseSensitive ? string : string.lowercased()
        let searchString = caseSensitive ? highlight : highlight.lowercased()
        let range = (inputString as NSString).range(of: searchString)
        
        attributedString.addAttribute(
            .foregroundColor,
            value: highlightColor,
            range: range)
        
        attributedString.addAttribute(
            .font,
            value: highlightFont,
            range: range)
        
        return attributedString
    }
    
}

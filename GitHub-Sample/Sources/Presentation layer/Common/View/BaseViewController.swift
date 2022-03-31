//
//  BaseViewController.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 28.03.2022.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - Private properties
    
    private struct KeyboardInfo {
        let frame: CGRect
        let curve: UIView.AnimationOptions
        let duration: TimeInterval
        let padding: CGFloat
    }
    
    // MARK: - Internal properties
    
    var bindBottomToKeyboardFrame: NSLayoutConstraint? { nil }
    
    // MARK: - Keyboard Binding
    
    func bindToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillChangeFrame),
                                               name: UIWindow.keyboardWillChangeFrameNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(notification:)),
                                               name: UIWindow.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func unbindFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIWindow.keyboardWillChangeFrameNotification,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIWindow.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    private func keyboardFrameWillChangeFrame(info: KeyboardInfo) {
        if let constraint = self.bindBottomToKeyboardFrame {
            self.bindBottomToKeyboardFrame(constraint, info: info)
        }
    }
    
    private func keyboardFrameWillHide(info: KeyboardInfo) {
        if let constraint = self.bindBottomToKeyboardFrame {
            self.bindBottomToKeyboardFrame(constraint, info: info)
        }
    }
    
    private func bindBottomToKeyboardFrame(_ bottomConstraint: NSLayoutConstraint, info: KeyboardInfo) {
        bottomConstraint.constant = info.padding
        
        var constraintView = bottomConstraint.firstItem as? UIView
        constraintView = constraintView ?? bottomConstraint.secondItem as? UIView
        
        guard let animateView = constraintView else { return }
        
        UIView.animate(
            withDuration: info.duration,
            delay: 0.0,
            options: info.curve,
            animations: {
                animateView.layoutIfNeeded()
            }, completion: nil)
    }
    
    @objc private func keyboardWillChangeFrame(notification: Notification) {
        guard let info = self.keyboardInfo(from: notification) else {
            return
        }
        self.keyboardFrameWillChangeFrame(info: info)
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        guard let info = self.keyboardInfo(from: notification) else {
            return
        }
        self.keyboardFrameWillHide(info: info)
    }
    
    private func keyboardInfo(from notification: Notification) -> KeyboardInfo? {
        guard
            let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let curveValue = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber,
            let durationValue = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber
        else {
            return nil
        }
        
        let duration = TimeInterval(durationValue.doubleValue)
        let keyboardFrame = self.view.convert(keyboardFrameValue.cgRectValue, from: nil)
        let curve = UIView.AnimationOptions(rawValue: curveValue.uintValue)
        let padding = max(self.view.frame.height - keyboardFrame.minY, 0)
        
        return KeyboardInfo(frame: keyboardFrame, curve: curve, duration: duration, padding: padding)
    }
    
}

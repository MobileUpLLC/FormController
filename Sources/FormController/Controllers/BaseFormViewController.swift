//
//  BaseFormViewController.swift
//  FormController
//
//  Created by Petrovich on 08.11.2021.
//

import UIKit

// MARK: - BaseFormViewController

open class BaseFormViewController: UIViewController {
    
    // MARK: - Public properties
    
    open var aboveKeyboardViewBottomInset: CGFloat = 0
    open var aboveKeyboardView: UIView? { nil }
    open var animatedUpAboveContainer: Bool = true
    open var initialInputView: UIView? { nil }
    
    // MARK: - Private properties
    
    private var safeAreaBottomInset: CGFloat { view.safeAreaInsets.bottom }
    private var isKeyboardShown = false
    private let validator = FieldValidator()
    
    // MARK: - Override methods
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeOnKeyboard()
        
        if let initialInputView = initialInputView {
            animatedUpAboveContainer = false
            initialInputView.becomeFirstResponder()
        }
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        unsubscribeOnKeyboard()
    }
    
    // MARK: - Public methods
    
    public func register(field: ValidatableField, rules: [Rule]) {
        validator.register(field: field, rules: rules)
        
        field.onValueChange = { [weak self] _ in
            
            if field.validatableState != .default {
                field.validatableState = .default
            }
            self?.fieldDidChangeValue(field)
        }
    }
    
    public func unregister(field: ValidatableField) {
        validator.unregister(field: field)
    }
    
    public func unregisterAll() {
        validator.unregisterObjects()
    }
    
    public func validate(field: ValidatableField, rules: [Rule]) -> FieldValidationResult {
        return validator.validate(field: field, rules: rules)
    }
    
    public func validate(completion: (FormValidationResult) -> Void) {
        validator.validate(completion: completion)
    }
    
    public func fieldDidChangeValue(_ field: ValidatableField) { }
    
    // MARK: - Public methods
    
    open func keyboardDidShow() {
        animatedUpAboveContainer = true
        isKeyboardShown = true
    }
    
    open func keyboardWillShow() {}
    open func keyboardWillHide() {}
    
    open func keyboardDidHide() {
        isKeyboardShown = false
    }
    
    open func subscribeOnKeyboard() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(notificationKeyboard(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(notificationKeyboard(notification:)),
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(notificationKeyboard(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(notificationKeyboard(notification:)),
            name: UIResponder.keyboardDidHideNotification,
            object: nil
        )
    }
    
    open func unsubscribeOnKeyboard() {
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        validator.unregisterObjects()
    }
    
    // MARK: - Private methods
    
    @objc private func notificationKeyboard(notification: Notification) {
        
        guard
            
            aboveKeyboardView != nil,
            let userInfo = notification.userInfo,
            let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        
        else { return }
        
        let endHeight = endFrame.height
        let animationCurve = UIView.AnimationOptions(rawValue: UInt(curveValue << 16))
        let options: UIView.AnimationOptions = [.beginFromCurrentState, animationCurve]
        
        switch notification.name {
        
        case UIResponder.keyboardWillShowNotification:
            keyboardWillShow(with: endHeight, duration: duration, options: options)
        case UIResponder.keyboardDidShowNotification:
            keyboardDidShow()
        case UIResponder.keyboardWillHideNotification:
            keyboardWillHide(with: endHeight, duration: duration, options: options)
        case UIResponder.keyboardDidHideNotification:
            keyboardDidHide()
        default:
            break
        }
    }
    
    private func keyboardWillShow(with height: CGFloat, duration: TimeInterval, options: UIView.AnimationOptions) {
        if isKeyboardShown == false {
            aboveKeyboardViewBottomInset = aboveKeyboardView?.findConstraint(type: .bottom)?.constant ?? .zero
        }
        
        keyboardWillShow()
        
        animateContentView(duration: duration, options: options, bottomOffset: height - safeAreaBottomInset)
    }
    
    private func keyboardWillHide(with height: CGFloat, duration: TimeInterval, options: UIView.AnimationOptions) {
        keyboardWillHide()
        
        animateContentView(duration: duration, options: options, bottomOffset: aboveKeyboardViewBottomInset)
    }
    
    private func animateContentView(duration: Double, options: UIView.AnimationOptions, bottomOffset: CGFloat) {
        aboveKeyboardView?.setConstraint(type: .bottom, value: bottomOffset)
        
        if animatedUpAboveContainer {
            
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                
                self.view.layoutIfNeeded()
            })
        }
    }
}

extension UIView {
    
    func setConstraint(type: NSLayoutConstraint.Attribute, value: CGFloat) {
        if let constraint = findConstraint(type: type) {
            
            constraint.constant = value
        }
    }
    
    func findConstraint(type: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        if let constraint = findConstraintInSuperview(type: type) {
            
            return constraint
        }
        
        return constraints.first(where: { $0.firstAttribute == type &&  $0.secondAttribute != type })
    }
    
    func findConstraintInSuperview(type: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        if let superview = superview {
            
            for constraint in superview.constraints {
                
                let isFirstItemIsSelf = (constraint.firstItem as? UIView) == self
                let isSecondItemIsSelf = (constraint.secondItem as? UIView) == self
                let isConstraintAssociatedWithSelf = (isFirstItemIsSelf || isSecondItemIsSelf)
                
                if constraint.firstAttribute == type && isConstraintAssociatedWithSelf {
                    
                    return constraint
                }
            }
        }
        
        return nil
    }
}

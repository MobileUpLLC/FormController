//
//  ValidatableField.swift
//  FormController
//
//  Created by Petrovich on 08.11.2021.
//

import Foundation

// MARK: - ValidatableFieldState

enum ValidatableFieldState: Equatable {
    
    case success
    case error(String? = nil)
    case `default`
    
    var isDefault: Bool { self == ValidatableFieldState.default }
}

// MARK: - ValidatableField

protocol ValidatableField: AnyObject {
    
    typealias ValueCallback = (String) -> Void
    
    // MARK: - Public properties
    
    var value: String { get }
    var validatableState: ValidatableFieldState { get set }
    var onValueChange: ValueCallback? { get set }
}

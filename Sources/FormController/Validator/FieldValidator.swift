//
//  FieldValidator.swift
//  FormController
//
//  Created by Petrovich on 08.11.2021.
//

import Foundation

// MARK: - ValidatableFieldResult

public struct ValidatableFieldResult {
    
    // MARK: - Public properties
    
    public weak var object: ValidatableField?
    public let errorMessage: String?
}

// MARK: - FormValidationResult

public struct FormValidationResult {
    
    // MARK: - Public properties

    public let isSuccess: Bool
    public let failedFields: [ValidatableFieldResult]
    public let successFields: [ValidatableFieldResult]
}

// MARK: - FieldValidationResult

public struct FieldValidationResult {
    
    // MARK: - Public properties

    public let isSuccess: Bool
    public let firstFailedRule: Rule?
}

// MARK: - ValidatableItem

public struct ValidatableItem {
    
    // MARK: - Public properties
    
    public weak var field: ValidatableField?
    public let rules: [Rule]
    
    // MARK: - Public methods
    
    public func validate() -> FieldValidationResult {
        if let firstFailedRule = rules.first(where: { $0.validate(value: field?.value ?? "") == false }) {
            return FieldValidationResult(isSuccess: false, firstFailedRule: firstFailedRule)
        } else {
            return FieldValidationResult(isSuccess: true, firstFailedRule: nil)
        }
    }
}

// MARK: - FieldValidator

public class FieldValidator {
    
    // MARK: - Private properties
    
    private var validatableItems: [ValidatableItem] = []
        
    // MARK: - Public methods
    
    public func register(field: ValidatableField, rules: [Rule]) {
        validatableItems.append(ValidatableItem(field: field, rules: rules))
    }
    
    public func unregister(field: ValidatableField) {
        if let fieldIndex = validatableItems.firstIndex(where: { $0.field === field }) {
            validatableItems.remove(at: fieldIndex)
        }
    }
    
    public func unregisterObjects() {
        validatableItems.removeAll()
    }
    
    public func validate(field: ValidatableField, rules: [Rule]) -> FieldValidationResult {
        let validatableItem = ValidatableItem(field: field, rules: rules)
        return validatableItem.validate()
    }
    
    public func validate(completion: (FormValidationResult) -> Void) {
        var failedFields: [ValidatableFieldResult] = []
        var successFields: [ValidatableFieldResult] = []
        
        validatableItems.forEach { validatableItem in
            
            let fieldValidationResult = validatableItem.validate()
            if let field = validatableItem.field, fieldValidationResult.isSuccess == false {
                let firstFailedRule = fieldValidationResult.firstFailedRule
                failedFields.append(ValidatableFieldResult(object: field, errorMessage: firstFailedRule?.errorMessage))
                field.validatableState = .error(firstFailedRule?.errorMessage)
            } else {
                successFields.append(ValidatableFieldResult(object: validatableItem.field, errorMessage: nil))
                validatableItem.field?.validatableState = .success
            }
        }
        
        let result = FormValidationResult(
            isSuccess: failedFields.isEmpty,
            failedFields: failedFields,
            successFields: successFields
        )
        
        completion(result)
    }
}

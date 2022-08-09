//
//  RegexRule.swift
//  FormController
//
//  Created by Petrovich on 08.11.2021.
//

import Foundation

// MARK: - RegexRule

open class RegexRule: Rule {
    
    // MARK: - Public propertries
    
    public let regex: String
    open var errorMessage: String? { nil }

    // MARK: - Public methods
    
    public init(regex: String) {
        self.regex = regex
    }
    
    public func validate(value: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", self.regex).evaluate(with: value)
    }
}

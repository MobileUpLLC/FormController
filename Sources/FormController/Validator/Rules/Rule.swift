//
//  Rule.swift
//  FormController
//
//  Created by Petrovich on 08.11.2021.
//

import Foundation

// MARK: - Rule

open protocol Rule {
    
    // MARK: - Public propertries
    
    var errorMessage: String? { get }
    
    // MARK: - Public method
    
    func validate(value: String) -> Bool
}

//
//  MinValueRule.swift
//  FormController
//
//  Created by Petrovich on 08.11.2021.
//

open class MinValueRule: Rule {
    
    open var errorMessage: String?
    public let min: Int
    
    public func validate(value: String) -> Bool {
        if let intValue = Int(value) {
            return intValue >= min
        }
        return false
    }
    
    public init(min: Int) {
        self.min = min
    }
}

//
//  MinLenghtRule.swift
//  FormController
//
//  Created by Petrovich on 08.11.2021.
//

open class MinLenghtRule: Rule {
    
    open var errorMessage: String?
    public let min: Int
    
    public func validate(value: String) -> Bool {
        return value.count >= min
    }
    
    public init(min: Int) {
        self.min = min
    }
}

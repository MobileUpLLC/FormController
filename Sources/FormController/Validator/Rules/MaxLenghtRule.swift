//
//  MaxLenghtRule.swift
//  FormController
//
//  Created by Petrovich on 08.11.2021.
//

open class MaxLenghtRule: Rule {
    
    var errorMessage: String? { nil }
    let max: Int
    
    func validate(value: String) -> Bool {
        return value.count <= max
    }
    
    init(max: Int) {
        self.max = max
    }
}

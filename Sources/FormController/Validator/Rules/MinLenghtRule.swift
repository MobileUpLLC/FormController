//
//  MinLenghtRule.swift
//  FormController
//
//  Created by Petrovich on 08.11.2021.
//

open class MinLenghtRule: Rule {
    
    var errorMessage: String?
    let min: Int
    
    func validate(value: String) -> Bool {
        return value.count >= min
    }
    
    init(min: Int) {
        self.min = min
    }
}

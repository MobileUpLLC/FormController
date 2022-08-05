//
//  MinValueRule.swift
//  FormController
//
//  Created by Petrovich on 08.11.2021.
//

class MinValueRule: Rule {
    
    var errorMessage: String?
    let min: Int
    
    func validate(value: String) -> Bool {
        if let intValue = Int(value) {
            return intValue >= min
        }
        return false
    }
    
    init(min: Int) {
        self.min = min
    }
}

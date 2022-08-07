//
//  MaxValueRule.swift
//  FormController
//
//  Created by Petrovich on 08.11.2021.
//

open class MaxValueRule: Rule {
    
    var errorMessage: String?
    let max: Int
    
    func validate(value: String) -> Bool {
        if let intValue = Int(value) {
            return intValue <= max
        }
        return false
    }
    
    init(max: Int) {
        self.max = max
    }
}

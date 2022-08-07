//
//  PhoneRule.swift
//  FormController
//
//  Created by Denis Sushkov on 17.05.2022.
//

open class PhoneRule: RegexRule {
    
    static let phoneRegex = "(\\+[0-9]+[\\-\\s]?)?(\\(?[0-9]+\\)?[\\-\\s]?)?([0-9][0-9\\-\\s]+[0-9])*"
    
    convenience init() {
        self.init(regex: PhoneRule.phoneRegex)
    }
}

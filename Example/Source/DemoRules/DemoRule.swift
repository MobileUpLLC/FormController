//
//  DemoRule.swift
//  FormController
//
//  Created by Илья Чуб on 05.07.2022.
//

import FormController

final class DemoRule: RegexRule {
    
    private enum Constants {
        
        static let demoRegex = "[a]*"
        static let errorMessage = "The string consists not only of the letters 'a'"
    }
    
    override var errorMessage: String? { Constants.errorMessage }
    
    convenience init() {
        self.init(regex: Constants.demoRegex)
    }
}

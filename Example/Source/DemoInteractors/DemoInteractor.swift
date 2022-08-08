//
//  DemoInteractor.swift
//  FormController
//
//  Created by Илья Чуб on 05.07.2022.
//

final class DemoInteractor {
    
    func getInitialData() -> [DemoValidatableViewModel] {
        return getDemoViewModels()
    }
    
    private func getDemoViewModels() -> [DemoValidatableViewModel] {
        return [
            DemoValidatableViewModel(
                title: "The string must be more than 5 characters long",
                content: "SPb",
                placeholder: nil
            ),
            DemoValidatableViewModel(
                title: "This field should contain the phone number",
                content: "-1234567891",
                placeholder: nil
            ),
            DemoValidatableViewModel(
                title: "This string must consist only of the letters 'a' and have a length of less than five characters",
                content: nil,
                placeholder: nil
            ),
        ]
    }
}

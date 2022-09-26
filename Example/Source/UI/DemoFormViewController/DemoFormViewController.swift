//
//  DemoFormViewController.swift
//  FormController
//
//  Created by foggydawning on 05.07.2022.
//

import UIKit
import FormController

final class DemoFormViewController: FormViewController {
    
    private enum Constants {
        
        static let demoModelFirstTitle = "The string must be more than 5 characters long"
        static let demoModelSecondTitle = "This field should contain the phone number"
        static let demoModelThirdTitle = """
        This string must consist only of the letters 'a'
        and have a length of less than five characters
        """
        static let demoModelFirstContent = "SPb"
        static let demoModelSecondContent = "-1234567891"
        static let navigationBarTitle = "FormController"
        static let successMessage = "Success"
        static let buttonYInsets: CGFloat = 32
        static let validatableFieldOneMinLenght = 6
        static let validatableFieldThreeMinLenght = 1
        static let validatableFieldThreeMaxLenght = 4
    }

    override var aboveKeyboardView: UIView? { scrollView }
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var validatableFieldOne: DemoValidatableView!
    @IBOutlet private weak var validatableFieldTwo: DemoValidatableView!
    @IBOutlet private weak var validatableFieldThree: DemoValidatableView!
    @IBOutlet private weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupScrollView()
        registerFields()
        setupFields()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = Constants.navigationBarTitle
    }
    
    private func setupScrollView() {
        scrollView.contentInset.bottom = doneButton.frame.height + Constants.buttonYInsets
    }
    
    private func registerFields() {
        register(field: validatableFieldOne, rules: [MinLenghtRule(min: Constants.validatableFieldOneMinLenght)])
        register(field: validatableFieldTwo, rules: [PhoneRule()])
        register(
            field: validatableFieldThree,
            rules: [
                DemoRule(),
                MaxLenghtRule(max: Constants.validatableFieldThreeMaxLenght),
                MinLenghtRule(min: Constants.validatableFieldThreeMinLenght)
            ]
        )
    }
    
    private func setupFields() {
        validatableFieldOne.setup(
            with: .init(
                title: Constants.demoModelFirstTitle,
                content: Constants.demoModelFirstContent,
                placeholder: nil
            )
        )
        validatableFieldTwo.setup(
            with: .init(
                title: Constants.demoModelSecondTitle,
                content: Constants.demoModelSecondContent,
                placeholder: nil
            )
        )
        validatableFieldThree.setup(
            with: .init(
                title: Constants.demoModelThirdTitle,
                content: nil,
                placeholder: nil
            )
        )
    }
    
    @IBAction private func didTapScrollView() {
        view.endEditing(true)
    }
    
    @IBAction private func didTapDoneButton() {
        validate { result in
            if result.isSuccess {
                print(Constants.successMessage)
            }
        }
    }
}

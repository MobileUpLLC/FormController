//
//  DemoFormViewController.swift
//  FormController
//
//  Created by foggydawning on 05.07.2022.
//

import UIKit

final class DemoFormViewController: BaseFormViewController {
    
    private enum Constants {
        
        static let scrollViewButtomInset: CGFloat = 86
        static let navigationBraTitle = "FormController"
        static let successMessage = "Success"
        static let validatableFieldOneIndex = 0
        static let validatableFieldTwoIndex = 1
        static let validatableFieldThreeIndex = 2
        static let validatableFieldOneMinLenght = 6
        static let validatableFieldThreeMinLenght = 1
        static let validatableFieldThreeMaxLenght = 4
    }

    override var aboveKeyboardView: UIView? { scrollView }
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var validatableFieldOne: DemoValidatableView!
    @IBOutlet weak var validatableFieldTwo: DemoValidatableView!
    @IBOutlet weak var validatableFieldThree: DemoValidatableView!
    @IBOutlet private weak var button: UIButton!
    
    private let interactor = DemoInteractor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupScrollView()
        registerFields()
        setupInitialData()
    }
    
    static func initiate() -> Self {
        return Self(nibName: String(describing: self), bundle: nil)
    }
    
    @IBAction private func didTapScrollView() {
        view.endEditing(true)
    }
    
    @IBAction private func didTapButton() {
        validate { result in
            if result.isSuccess {
                print(Constants.successMessage)
            }
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = Constants.navigationBraTitle
    }
    
    private func setupScrollView() {
        scrollView.contentInset.bottom = Constants.scrollViewButtomInset
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
    
    private func setupInitialData() {
        let models = interactor.getInitialDate()
        
        validatableFieldOne.setup(with: models[Constants.validatableFieldOneIndex])
        validatableFieldTwo.setup(with: models[Constants.validatableFieldTwoIndex])
        validatableFieldThree.setup(with: models[Constants.validatableFieldThreeIndex])
    }
}

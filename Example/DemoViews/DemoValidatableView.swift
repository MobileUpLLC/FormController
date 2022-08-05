//
//  DemoValidatableView.swift
//  FormController
//
//  Created by foggydawning on 05.07.2022.
//

import UIKit

final class DemoValidatableView: UIView, ValidatableField {
    
    private enum Constants {
        
        static let textFieldDefauldString = ""
        static let textFieldMaxBorderWidth: CGFloat = 1
        static let textFieldMinBorderWidth: CGFloat = 0
        static let defaultErrorLabel = "Error"
    }
    
    var value: String { textField.text ?? Constants.textFieldDefauldString }
    var validatableState: ValidatableFieldState = .default { didSet { updateValidatableState() } }
    var onValueChange: ValueCallback?
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layoutView()
        updateValidatableState()
    }
    
    func setup(with item: DemoValidatableViewModel) {
        titleLabel.text = item.title
        textField.text = item.content
        textField.placeholder = item.placeholder
    }
    
    private func layoutView() {
        guard let view = loadViewFromNib() else { return }

        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false

        addConstraints([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func loadViewFromNib() -> UIView? {
        let nibName = String(describing: Self.self)
        let nib = UINib(nibName: nibName, bundle: Bundle(for: Self.self))
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    private func updateValidatableState() {
        switch validatableState {
        case .error(let errorDescription):
            errorLabel.text = errorDescription ?? Constants.defaultErrorLabel
            textField.layer.borderWidth = Constants.textFieldMaxBorderWidth
            textField.layer.borderColor = UIColor.red.cgColor
            errorLabel.isHidden = false
        default:
            textField.layer.borderWidth = Constants.textFieldMinBorderWidth
            textField.layer.borderColor = UIColor.gray.cgColor
            errorLabel.isHidden = true
        }
    }
}

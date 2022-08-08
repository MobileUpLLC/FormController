# FormController!

[![githubIcon](https://user-images.githubusercontent.com/80983073/183376145-9738e9ca-1fc8-413a-9d01-75871731476b.png)](https://github.com/MobileUpLLC/FormController/new/main)
[![githubIcon-1](https://user-images.githubusercontent.com/80983073/183376152-fcdff7f9-8971-4250-90df-622f792c9ef9.png)](https://developer.apple.com/documentation/xcode-release-notes/swift-5-release-notes-for-xcode-10_2)
[![githubIcon-2](https://user-images.githubusercontent.com/80983073/183376159-db6fa792-44b5-4639-aa4c-d8c72a7ec28e.png)](https://developer.apple.com)
[![githubIcon-3](https://user-images.githubusercontent.com/80983073/183376162-1e432ab7-fe11-4c66-95a6-38c2687401d7.png)](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app)
[![githubIcon-4](https://user-images.githubusercontent.com/80983073/183376168-2e38a743-39ed-461d-bca1-230866f5608c.png)](https://github.com/MobileUpLLC/FormController/blob/main/LICENSE)

Easy-to-use library with all the necessary logic to control the screen with custom fields that support data entry and validation.
![image](https://user-images.githubusercontent.com/80983073/183396205-a0be7fbc-d5db-4d24-b8b1-ae161434a640.png)
![image](https://user-images.githubusercontent.com/80983073/183376960-c53fa417-2da1-4932-89f3-fe3f8701daa3.png)

## Features

- Manage screen with number of input-fields with custom UI you need
- Use optional and required input-fields
- Field-validation with succes, error and default status
- Taking value for validation, state for change field appearence and a callback on value change
- Open Validation-Rule Protocol for creating custom Rules
- Keyboard up-down tracking

## Usage

### 1. View fields for validation

#### 1.1. Create View
View should implement ```ValidatableField``` protocol, that requires to override three variables: 
```value``` – validated value
```validatableState``` – the current state of field (successful, error, default)
```onValueChange``` – callback, which will be triggered on the change of the field value

In example validatable view is declared as ```DemoValidatableView: UIView, ValidatableField``` and overrides variables this way:
```
var value: String { textField.text ?? Constants.textFieldDefauldString }
var validatableState: ValidatableFieldState = .default { didSet { updateValidatableState() } }
var onValueChange: ValueCallback?
```

When field validates, ```validatableState``` will get its state. Depending on this state, the UI should also be changed. We did this with  ```didSet``` and the ```updateValidatableState()``` function. 

```
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
```

![image](https://user-images.githubusercontent.com/80983073/183380442-cf317b6e-c510-46d8-bf68-96e2ad88cd1e.png)


### 2.  Rules

For example will be followed those rules:
- The first field must have a string length greater than 5 characters. 
- The second field will have a phone number in the string. 
- The third field will have two rules: the string length must be less than 5 characters, and the characters themselves must only be the letters 'a'.

To create rule need's to implement ```Rule ``` protocol. ```Rule ``` requires to write a validation function ```validate ``` and a property ```errorMessage ``` – a description of why the field failed validation by this rule. 

#### 2.1. Length-rule 
The rule for the first field will be defined later using a ready-made class ```MinLenghtRule```.

#### 2.2. Regex
The package contains a class ```RegexRule``` that implements protocol ```Rule```. This class aimed to work with regular expressions, which needed to check that the string is really a phone number. In the initializer of this class should passed one parameter - the regular expression. Example of the implementation: 

```
class PhoneRule: RegexRule {
    
    static let phoneRegex = "(\\+[0-9]+[\\-\\s]?)?(\\(?[0-9]+\\)?[\\-\\s]?)?([0-9][0-9\\-\\s]+[0-9])*"
    
    convenience init() {
        self.init(regex: PhoneRule.phoneRegex)
    }
}
```

#### 2.3. Custom Regex Rules
The rules for the third field can be defined using two classes ```MaxLenghtRule``` and a class that inherits from ```RegexRule```. Example regex rule implementation:

 ```
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
 ```
 
 ### 3. Controller's logic and UI

There are few implementation features. 
- First: All fields should be in UIScrollView to keep an ability for lift up the keyboard and scroll to the desired field. 
- Second: Button should be outside UIScrollVIew and have constraint to the bottom of UIScrollView. 
- And third: Controller should have access to the scrollView, the button and the fields in some way.
 
#### 3.1 Setup Keyboard
Override ```aboveKeyboardView``` variable . This variable is responsible for View, which will be raised with keyboard up. 

```
override var aboveKeyboardView: UIView? { scrollView }
 ```
 
#### 3.2 Place necessary functions
Override ```viewDidLoad()```. Include in this function fields-registation and view's-initialization

 ```
override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavigationBar()
    registerFields()
    setupInitialData()
    setupScrollView()
}
 ```
 
#### 3.3 Setup Validator
1. Create validator object  ```validator = FieldValidator()```.

2. Then register field's for validating. 

```
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
```

Here fields relates to the rule by which it should be checked. 

3. Start validation. 
Validator has a function ```validator.validate(completion: completion)``` that goes through all the fields and validates them. To start the validation call this function. In our example we want to validate fields after user touches up inside button, so we place validate functions inside IBAction.

#### 3.4 Optional settings
In case of using ViewModels to configure inpit-fields, call ```setupInitialData()``` to setup views.

``` 
private func setupInitialData() {
    let models = interactor.getInitialDate()
        
    validatableFieldOne.setup(with: models[Constants.validatableFieldOneIndex])
    validatableFieldTwo.setup(with: models[Constants.validatableFieldTwoIndex])
    validatableFieldThree.setup(with: models[Constants.validatableFieldThreeIndex])
}
```

## Requirements

- Swift 5.0 +
- iOS 12.0 +

## Installation

FormController doesn't contain any external dependencies.

### CocoaPods

Will be soon

### Manual

Download and drag files from Source folder into your Xcode project.

### Swift Package Manager Install

Swift Package Manager 

```
dependencies: [
    .package(url: "https://github.com/MobileUpLLC/FormController", .upToNextMajor(from: "0.0.1"))
]
```

## License

FormController is distributed under the [MIT License](https://github.com/MobileUpLLC/FormController/blob/main/LICENSE).

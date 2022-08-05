# FormController
## Create and Validate custom forms

BaseFormViewController - это контроллер, в который заложена вся необходимая логика для управления экраном с полями, в которые пользователь должен вводить данные и которые необходимо валидировать.

# Использование

Для того, чтобы всё начало работать, требуется сделать несколько простых действий:
- создаём View полей для валидации, поддерживая протокол ```ValidatableField```
- создаём необходимые правила, по которым будет происходить валидация, поддерживая протокол Rule
- создаём свой собственный ```ViewController```, наследуя его от ```BaseFormViewController```, верстаем его UI и настраиваем логику его поведения небольшим количеством методов

# Пример использования
Предположим, что мы имеем необходимость создать экран с тремя одинаковыми по виду валидируемыми полями, у каждого из которых будет свое правило (или правила). Снизу экрана расположим кнопку, по тапу на которую будет запускаться проверка. Пойдем по списку действий, описанному выше.

## 1.  View полей для валидации
Итак, что должно быть у View поля? На самом деле, не так много. Протокол ```ValidatableField``` обязывает нас прописать всего три переменные: 
```value``` - значение, которое мы будем валидировать
```validatableState``` - текущее состояние этого поля (успешно, ошибка, дефолт)
```onValueChange``` - коллбек, который будет тригериться на изменение значения поля

Назовем нашу View ```DemoValidatableView: UIView, ValidatableField```. Пропишем эти три переменные:
```
var value: String { textField.text ?? Constants.textFieldDefauldString }
var validatableState: ValidatableFieldState = .default { didSet { updateValidatableState() } }
var onValueChange: ValueCallback?
```

При валидации поля в ```validatableState``` будет попадать его состояние. В зависимости от этого состояния нужно изменять и UI. Как видно из кода выше, мы сделали это с помощью ```didSet``` и функции ```updateValidatableState()```. 

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

Осталось сверстать элементы и настроить их расположение друг относительно друга. В демонстрационном проекте это сделано с помощью Xib’а. Смотри файлы DemoValidatableView.swift и DemoValidatableView.xib. 

![image](https://user-images.githubusercontent.com/80983073/183074944-37d6a5fe-b3e0-46e8-9ad4-7af4cbd7df88.png)

## 2.  Правила
Пусть правила будут такими. У первого поля длина строки должна быть больше, чем 5 символов. У второго поля в строке будет телефонный номер. У третьего поля будет сразу два правила: длина строки меньше 5 символов, а сами символы должны быть только буквами ‘a’.

Посмотрим на протокол ```Rule```. С ним всё не сильно сложнее, чем с предыдущим протоколом. Он обязывает нас прописать только функцию валидирования ```validate``` и проперти ```errorMessage``` – описание того, почему поле не прошло валидацию по этому правилу. 

### 2.1.
Правило для первого поля можно будет впоследствии задать с помощью готового класса ```MinLenghtRule```.

### 2.2.
Тут нужен небольшой комментарий. В пакете предусмотрен класс ```RegexRule```. Он поддерживает протокол ```Rule```. Как понятно из названия - направлен на работу с регулярными выражениями, что нам и понадобится для проверки на то, что введенная строка - действительно номер телефона. В инициализатор этого класса нужно передать только один параметр - регулярное выражение. Посмотрим на реализацию: 

```
class PhoneRule: RegexRule {
    
    static let phoneRegex = "(\\+[0-9]+[\\-\\s]?)?(\\(?[0-9]+\\)?[\\-\\s]?)?([0-9][0-9\\-\\s]+[0-9])*"
    
    convenience init() {
        self.init(regex: PhoneRule.phoneRegex)
    }
}
 ```
 
### 2.3.
Правила для третьего поля можно будет задать с помощью двух классов ```MaxLenghtRule``` и класса, который унаследован от ```RegexRule```. Посмотрим на реализацию последнего:

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
 
Отлично! Правила готовы и мы можем начать реализовывать самое главное - контроллер. 
 
## 3.  Контроллер. Его логика и UI

Есть особенности реализации, о которых стоит сказать. Первое. Все поля должны находиться в UIScrollView, чтобы при нехватке места на экране при поднятии клавиатуры пользователь имел возможность проскроллить до нужного поля. Второе. Кнопка должна быть вне UIScrollVIew и прибита констрейнтом к низу UIScrollView. И последнее. Важно, чтобы у контроллера каким-либо образом был доступ к скрол вью, кнопке и полям. Этот момент станет очевиден в ходе дальнейших рассуждений.
 
Перезапишем переменную ```aboveKeyboardView```. Эта переменная отвечает за View, которое будет подниматься вместе с поднятием клавиатуры. 

```
override var aboveKeyboardView: UIView? { scrollView }
 ```
 
Перезапишем ```viewDidLoad```. Выполним в нем ряд важных, но простых действий. Оговорим только самые важные из них

 ```
override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavigationBar()
    registerFields()
    setupInitialData()
    setupScrollView()
}
 ```
 
У ```BaseFormViewController``` есть валидатор ```validator = FieldValidator()```. Что минимально необходимо о нем знать? Это то, что у него есть функция ```validator.validate(completion: completion)```, которая проходится по всем полям и проверяет их. Трогать валидатор напрямую не надо – у ```BaseFormViewController``` есть функция ```validate(completion: (FormValidationResult) -> Void)```, она сделает это сама. 

Но как валидатор узнает, какие поля ему валидировать? Ответ достаточно прост. Для того, чтобы валидатор знал поля, для этого их нужно зарегистрировать. Как видно выше, мы сделали это с помощью функции ```registerFields()```. Давайте посмотрим на ее реализацию. 
 
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
 
Как видно из кода, мы явно указываем, что поле такое-то нужно проверять по такому-то правилу. Просто, не так ли?

Следующий важный шаг. При открытии нашего экрана в полях уже могут быть какие-то данные. Они могут быть взяты из базы данных, с сервера или еще откуда-то. Их может и не быть. Но если они всё-таки есть, хорошо бы их отобразить сразу. Мы сделали это в функции ```setupInitialData()```.
 
 ```
private func setupInitialData() {
    let models = interactor.getInitialDate()
        
    validatableFieldOne.setup(with: models[Constants.validatableFieldOneIndex])
    validatableFieldTwo.setup(with: models[Constants.validatableFieldTwoIndex])
    validatableFieldThree.setup(with: models[Constants.validatableFieldThreeIndex])
}
 ```
 
Осталось дело за малым. Подключить действие кнопки и сверстать UI. В демонстрационном проекте это, опять же, сделано через Xib. Смотри реализацию в файлах DemoFormViewController.swift и  DemoFormViewController.xib. 

![image](https://user-images.githubusercontent.com/80983073/183074879-b37e53f9-042a-4d69-8c0f-6a80a1578f42.png)

Что имеем на текущий момент при запуске проекта? В принипе, то, что мы и задумывали изначально: 
![image](https://user-images.githubusercontent.com/80983073/183074769-e629a54d-5b14-41ae-9be7-ca02cb37c509.png)
![image](https://user-images.githubusercontent.com/80983073/183074812-c13311d3-09ed-4d36-b9d5-e831af7039de.png)

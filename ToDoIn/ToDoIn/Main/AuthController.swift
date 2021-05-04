import UIKit

class AuthController: UIViewController {
    
    private var isSignIn: Bool
    
    private var numberTextField = UITextField()
    private var passwordTextField1 = UITextField()
    private var passwordTextField2 = UITextField()
    private var button = UIButton()
    
    init(isSignIn: Bool) {
        self.isSignIn = isSignIn
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackground()
        hideKeyboardWhenTappedAround()
        
        numberTextField.placeholder = "Номер телефона"
        numberTextField.backgroundColor = .gray

        passwordTextField1.placeholder = "Пароль"
        passwordTextField1.isSecureTextEntry = true
        passwordTextField1.backgroundColor = .gray
        passwordTextField2.placeholder = "Повторите пароль"
        passwordTextField2.isSecureTextEntry = true
        passwordTextField2.backgroundColor = .gray


        button.setTitle(isSignIn ? "Войти" : "Зарегистрироваться", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.backgroundColor = .gray
        
        self.view.addSubviews(numberTextField, passwordTextField1, passwordTextField2, button)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        numberTextField.pin.center().sizeToFit()
        passwordTextField1.pin.below(of: numberTextField, aligned: .center).sizeToFit()
        if !isSignIn {
            passwordTextField2.pin.below(of: passwordTextField1, aligned: .center).sizeToFit()
        }
        button.pin.bottom(20).sizeToFit()
    }
    
    @objc
    func buttonTapped() {
        if isSignIn {
            guard let number = numberTextField.text,
                  let password = passwordTextField1.text else {
                return
            }
            if !number.isEmpty && !password.isEmpty {
                print("Sign In")
            }
        } else {
            guard let number = numberTextField.text,
                  let password1 = passwordTextField1.text,
                  let password2 = passwordTextField2.text else {
                return
            }
            if !number.isEmpty && !password1.isEmpty && !password2.isEmpty {
                print("Sign Up")
            }
        }
    }

}

import UIKit
import FirebaseAuth
import FirebaseFirestore

class AuthController: UIViewController {
    
    // MARK: - Properties
    
    private var presenter: AuthViewPresenter?
    
    private var isSignIn: Bool
    
    private var emailTextField = UITextField()
    private var nameTextField = UITextField()
    private var passwordTextField1 = UITextField()
    private var passwordTextField2 = UITextField()
    private var errorLabel = UILabel()
    private var button = UIButton()
    
    // MARK: - Init
    
    init(isSignIn: Bool) {
        self.isSignIn = isSignIn
        super.init(nibName: nil, bundle: nil)
        self.presenter = AuthPresenter(authView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configures
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackground()
        hideKeyboardWhenTappedAround()
        
        [emailTextField, nameTextField, passwordTextField1, passwordTextField2, button].forEach {
            $0.backgroundColor = .gray
        }
        
        emailTextField.placeholder = "Почта"
        nameTextField.placeholder = "Имя"
        passwordTextField1.placeholder = "Пароль"
        passwordTextField1.isSecureTextEntry = true
        passwordTextField2.placeholder = "Повторите пароль"
        passwordTextField2.isSecureTextEntry = true
        
        errorLabel.alpha = 0

        button.setTitle(isSignIn ? "Войти" : "Зарегистрироваться", for: .normal)
        button.addTarget(self, action: #selector(buttonSignTapped), for: .touchUpInside)
        
        self.view.addSubviews(emailTextField, nameTextField, passwordTextField1, passwordTextField2, button, errorLabel)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emailTextField.pin
            .top(20)
            .size(CGSize(width: 200, height: 30))
        if !isSignIn {
            nameTextField.pin
                .below(of: emailTextField, aligned: .center)
                .size(CGSize(width: 200, height: 30))
        }
        passwordTextField1.pin
            .below(of: isSignIn ? emailTextField : nameTextField, aligned: .center)
            .size(CGSize(width: 200, height: 30))
        if !isSignIn {
            passwordTextField2.pin
                .below(of: passwordTextField1, aligned: .center)
                .size(CGSize(width: 200, height: 30))
        }
        button.pin
            .bottom(20).hCenter()
            .size(CGSize(width: 200, height: 30))
        errorLabel.pin
            .above(of: button, aligned: .center)
            .size(CGSize(width: 200, height: 30))
    }
    
    
    // MARK: - Handlers

    @objc
    func buttonSignTapped() {
        var res = false
        if isSignIn {
            res = presenter?.buttonSignTapped(isSignIn: true) ?? false
        } else {
            res = presenter?.buttonSignTapped(isSignIn: false) ?? false
        }
        if res {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func transitionToMain() {
        dismiss(animated: true, completion: nil)
    }
}

extension AuthController: AuthView {
    func getEmail() -> String {
        emailTextField.text ?? ""
    }
    
    func getName() -> String {
        nameTextField.text ?? ""
    }
    
    func getPassword1() -> String {
        passwordTextField1.text ?? ""
    }
    
    func getPassword2() -> String {
        passwordTextField2.text ?? ""
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
        errorLabel.textColor = .red
    }
}

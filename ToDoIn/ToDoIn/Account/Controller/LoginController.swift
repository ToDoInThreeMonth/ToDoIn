import UIKit

protocol LoginView: class {
    func setPresenter(presenter: LoginViewPresenter, coordinator: AccountChildCoordinator)
}

class LoginController: UIViewController {

    // MARK: - Properties
    
    private var presenter: LoginViewPresenter?
    
    private var logoImageView = CustomImageView()
    private let buttonSignIn = CustomButton(with: "Войти")
    private let buttonSignUp = CustomButton(with: "Зарегистрироваться")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackground()
        
        navigationController?.configureBarButtonItems(screen: .login, for: self)
        
        configureButtons()
        
        view.addSubviews(buttonSignIn, buttonSignUp, logoImageView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureLayouts()
    }
    
    func configureLayouts() {
        logoImageView.pin
            .topCenter(view.pin.safeArea.top)
            .margin(30)
                
        buttonSignIn.pin
            .center()
        
        buttonSignUp.pin
            .below(of: buttonSignIn, aligned: .center)
            .marginTop(20)
    }
    
    func configureButtons() {
        buttonSignIn.addTarget(self, action: #selector(buttonSignInPressed), for: .touchUpInside)
        buttonSignUp.addTarget(self, action: #selector(buttonSignUpPressed), for: .touchUpInside)
    }
    
    @objc
    func buttonSignInPressed() {
        presenter?.buttonSignPressed(isSignIn: true)
    }
    
    @objc
    func buttonSignUpPressed() {
        presenter?.buttonSignPressed(isSignIn: false)
    }
}

extension LoginController: LoginView {
    func setPresenter(presenter: LoginViewPresenter, coordinator: AccountChildCoordinator) {
        self.presenter = presenter
        self.presenter?.setCoordinator(with: coordinator)
    }
}

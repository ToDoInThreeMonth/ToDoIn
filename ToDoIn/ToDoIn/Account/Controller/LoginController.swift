import UIKit

protocol LoginViewProtocol: AnyObject {
    func setPresenter(presenter: LoginPresenterProtocol, coordinator: AccountChildCoordinator)
}

final class LoginController: UIViewController {

    // MARK: - Properties
    
    private var presenter: LoginPresenterProtocol?
    
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
    
    private func configureLayouts() {
        logoImageView.pin
            .topCenter(view.pin.safeArea.top)
            .margin(30)
                
        buttonSignIn.pin
            .center()
        
        buttonSignUp.pin
            .below(of: buttonSignIn, aligned: .center)
            .marginTop(20)
    }
    
    private func configureButtons() {
        buttonSignIn.addTarget(self, action: #selector(buttonSignInPressed), for: .touchUpInside)
        buttonSignUp.addTarget(self, action: #selector(buttonSignUpPressed), for: .touchUpInside)
    }
    
    @objc
    private func buttonSignInPressed() {
        presenter?.buttonSignPressed(isSignIn: true)
    }
    
    @objc
    private func buttonSignUpPressed() {
        presenter?.buttonSignPressed(isSignIn: false)
    }
}

extension LoginController: LoginViewProtocol {
    func setPresenter(presenter: LoginPresenterProtocol, coordinator: AccountChildCoordinator) {
        self.presenter = presenter
        self.presenter?.setCoordinator(with: coordinator)
    }
}

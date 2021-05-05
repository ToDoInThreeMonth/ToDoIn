import UIKit

protocol LoginView: class {
    func setPresenter(presenter: LoginViewPresenter, coordinator: AccountChildCoordinator)
}

class LoginController: UIViewController {

    // MARK: - Properties
    
    private var presenter: LoginViewPresenter?
    
    let buttonSignIn = UIButton()
    let buttonSignUp = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonSignIn.backgroundColor = .gray
        buttonSignUp.backgroundColor = .gray
        
        buttonSignIn.setTitle("Войти", for: .normal)
        buttonSignUp.setTitle("Зарегистрироваться", for: .normal)
        
        buttonSignIn.addTarget(self, action: #selector(buttonSignInPressed), for: .touchUpInside)
        buttonSignUp.addTarget(self, action: #selector(buttonSignUpPressed), for: .touchUpInside)
        
        self.view.addSubviews(buttonSignIn, buttonSignUp)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        buttonSignIn.pin.center().sizeToFit()
        buttonSignUp.pin.below(of: buttonSignIn, aligned: .center).sizeToFit()
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

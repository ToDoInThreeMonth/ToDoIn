import UIKit
import FirebaseAuth
import FirebaseFirestore

protocol AuthView: class {
    
    func setPresenter(presenter: AuthViewPresenter, coordinator: AccountChildCoordinator)
    
    func getEmail() -> String
    func getName() -> String
    func getPassword1() -> String
    func getPassword2() -> String
    
    func showError(_ message:String)
    func transitionToMain()
}

class AuthController: UIViewController {
    
    // MARK: - Properties
    
    private var presenter: AuthViewPresenter?
    
    private var isSignIn: Bool
    
    struct LayersConstants {
        static let margin: CGFloat = 25
        static let textFieldInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        static let cornerRadius: CGFloat = 15
        static let buttonHeight: CGFloat = 40
        static let buttonCornerRadius: CGFloat = 15
        static let horizontalPadding: CGFloat = 40
        static let textFieldHeight: CGFloat = 35
    }
    
    private var emailTextField = CustomTextField(insets: LayersConstants.textFieldInsets)
    private var nameTextField = CustomTextField(insets: LayersConstants.textFieldInsets)
    private var passwordTextField1 = CustomTextField(insets: LayersConstants.textFieldInsets)
    private var passwordTextField2 = CustomTextField(insets: LayersConstants.textFieldInsets)
    private var errorLabel = UILabel()
    private var button = UIButton()
    
    private var imageView = UIImageView()

    
    // MARK: - Init
    
    init(isSignIn: Bool) {
        self.isSignIn = isSignIn
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configures
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackground()
        hideKeyboardWhenTappedAround()
        
        configureTextFields()
        configureAddButton()
        configureErrorLabel()
        configureImageView()
        
        self.view.addSubviews(imageView, emailTextField, nameTextField, passwordTextField1, passwordTextField2, button, errorLabel)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureLayouts()
        configureShadowsAndCornerRadius()
    }
    
    func configureLayouts() {
        
        if !isSignIn {
            imageView.pin.top(5)
                .hCenter()
                .height(150)
                .width(150)
        }
        
        emailTextField.pin
            .top(to: isSignIn ? view.edge.top : imageView.edge.bottom)
            .marginTop(isSignIn ? 100 : 10)
            .horizontally(LayersConstants.horizontalPadding)
            .height(LayersConstants.textFieldHeight)

        if !isSignIn {
            nameTextField.pin
                .below(of: emailTextField)
                .marginTop(LayersConstants.margin)
                .horizontally(LayersConstants.horizontalPadding)
                .height(LayersConstants.textFieldHeight)
        }
        
        passwordTextField1.pin
            .below(of: isSignIn ? emailTextField : nameTextField)
            .marginTop(LayersConstants.margin)
            .horizontally(LayersConstants.horizontalPadding)
            .height(LayersConstants.textFieldHeight)
        
        if !isSignIn {
            passwordTextField2.pin
                .below(of: passwordTextField1)
                .marginTop(LayersConstants.margin)
                .horizontally(LayersConstants.horizontalPadding)
                .height(LayersConstants.textFieldHeight)
        }
        
        errorLabel.pin
            .below(of: isSignIn ? passwordTextField1 : passwordTextField2 )
            .marginTop(LayersConstants.margin)
            .horizontally(LayersConstants.horizontalPadding)
            .height(LayersConstants.textFieldHeight)
        
        button.pin
            .below(of: errorLabel)
            .horizontally(LayersConstants.horizontalPadding)
            .height(LayersConstants.textFieldHeight)
    }
    
    func configureImageView() {
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "default")
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
    }
    
    func configureErrorLabel() {
        errorLabel.alpha = 0
        errorLabel.textAlignment = .center
    }
    
    func configureTextFields() {
        emailTextField.placeholder = "Почта"
        nameTextField.placeholder = "Имя"
        passwordTextField1.placeholder = "Пароль"
        passwordTextField1.isSecureTextEntry = true
        passwordTextField2.placeholder = "Повторите пароль"
        passwordTextField2.isSecureTextEntry = true
        [emailTextField, nameTextField, passwordTextField1, passwordTextField2].forEach {
            $0.textColor = .darkTextColor
            $0.backgroundColor = .white
        }
    }
    
    func configureAddButton() {
        button.setTitle(isSignIn ? "Войти" : "Зарегистрироваться", for: .normal)
        button.addTarget(self, action: #selector(buttonSignTapped), for: .touchUpInside)
        
        button.setTitleColor(.darkTextColor, for: .normal)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - LayersConstants.horizontalPadding * 2, height: LayersConstants.buttonHeight)
        gradientLayer.cornerRadius = LayersConstants.buttonCornerRadius
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.accentColor.cgColor]
        button.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func configureShadowsAndCornerRadius() {
        if nameTextField.layer.cornerRadius == 0 {
            imageView.makeRound()
            SettingsUIComponents.getImageViewShadow(imageView)
            [emailTextField, nameTextField, passwordTextField1, passwordTextField2, button].forEach { $0.layer.cornerRadius = LayersConstants.cornerRadius }
            [emailTextField, nameTextField, passwordTextField1, passwordTextField2, button].forEach { $0.addShadow(type: .outside, color: .white, power: 1, alpha: 1, offset: -1) }
            [emailTextField, nameTextField, passwordTextField1, passwordTextField2, button].forEach { $0.addShadow(type: .outside, power: 1, alpha: 0.15, offset: 1) }
        }
    }
    
    
    // MARK: - Handlers

    @objc
    func buttonSignTapped() {
        if isSignIn {
            presenter?.buttonSignInTapped()
        } else {
            presenter?.buttonSignUpTapped(photo: imageView.image)
        }
    }
    
    @objc
    func imageViewTapped() {
        ImagePickerManager().pickImage(self) { image in
            self.imageView.image = image
            SettingsUIComponents.getImageViewShadow(self.imageView)
            self.imageView.contentMode = .scaleAspectFill
        }
    }
    
    func transitionToMain() {
        dismiss(animated: true, completion: nil)
    }
}

extension AuthController: AuthView {
    
    func setPresenter(presenter: AuthViewPresenter, coordinator: AccountChildCoordinator) {
        self.presenter = presenter
        self.presenter?.setCoordinator(with: coordinator)
    }
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

import UIKit
import FirebaseAuth
import FirebaseFirestore

protocol AuthViewProtocol: AnyObject {
    
    func setPresenter(presenter: AuthPresenterProtocol, coordinator: AccountChildCoordinator)
    
    func getEmail() -> String
    func getName() -> String
    func getPassword1() -> String
    func getPassword2() -> String
    func getImage() -> UIImage?
    
    func showError(_ message:String)
    func transitionToMain()
    func stopActivityIndicator()
}

final class AuthController: UIViewController {
    
    // MARK: - Properties
    
    private var presenter: AuthPresenterProtocol?
    
    private var isSignIn: Bool
    
    private struct LayersConstants {
        static let margin: CGFloat = 25
        static let textFieldInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        static let cornerRadius: CGFloat = 15
        static let buttonHeight: CGFloat = 40
        static let buttonCornerRadius: CGFloat = 15
        static let horizontalPadding: CGFloat = 40
        static let textFieldHeight: CGFloat = 35
    }
    
    private let imageView = CustomImageView()
    private let emailTextField = CustomTextField(insets: LayersConstants.textFieldInsets)
    private let nameTextField = CustomTextField(insets: LayersConstants.textFieldInsets)
    private let passwordTextField1 = CustomTextField(insets: LayersConstants.textFieldInsets)
    private let passwordTextField2 = CustomTextField(insets: LayersConstants.textFieldInsets)
    private let errorLabel = UILabel()
    private let button = CustomButton()
    private let activityIndicator = UIActivityIndicatorView()

    
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
        
        if !isSignIn {
            configureImageView()
        }
        view.addSubviews(emailTextField, nameTextField, passwordTextField1, passwordTextField2, button, errorLabel, imageView)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureLayouts()
        configureShadowsAndCornerRadius()
    }
    
    private func configureLayouts() {
        
        imageView.pin
            .top(LayersConstants.margin)
            .hCenter()
            .height(150)
            .width(150)
        
        emailTextField.pin
            .top(to: imageView.edge.bottom)
            .marginTop(LayersConstants.margin)
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
        
        button.pin
            .below(of: isSignIn ? passwordTextField1 : passwordTextField2, aligned: .center)
            .marginTop(LayersConstants.margin * 2)
        
        errorLabel.pin
            .below(of: button)
            .marginTop(5)
            .horizontally(LayersConstants.horizontalPadding)
            .height(LayersConstants.textFieldHeight * 2)
    }
    
    private func configureImageView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
    }
    
    private func configureErrorLabel() {
        errorLabel.alpha = 0
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
    }
    
    private func configureTextFields() {
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
    
    private func configureAddButton() {
        button.setTitle(isSignIn ? "Войти" : "Зарегистрироваться")
        button.addTarget(self, action: #selector(buttonSignTapped), for: .touchUpInside)
    }
    
    private func configureShadowsAndCornerRadius() {
        if nameTextField.layer.cornerRadius == 0 {
            [emailTextField, nameTextField, passwordTextField1, passwordTextField2].forEach { $0.layer.cornerRadius = LayersConstants.cornerRadius }
            [emailTextField, nameTextField, passwordTextField1, passwordTextField2].forEach { $0.addShadow(type: .outside, color: .white, power: 1, alpha: 1, offset: -1) }
            [emailTextField, nameTextField, passwordTextField1, passwordTextField2].forEach { $0.addShadow(type: .outside, power: 1, alpha: 0.15, offset: 1) }
        }
    }
    
    
    // MARK: - Handlers

    @objc
    private func buttonSignTapped() {
        startActivityIndicator()
        if isSignIn {
            presenter?.buttonSignInTapped()
        } else {
            presenter?.buttonSignUpTapped()
        }
    }
    
    @objc
    private func imageViewTapped() {
        ImagePickerManager().pickImage(self) { image in
            self.imageView.setImage(with: image)
            self.imageView.contentMode = .scaleAspectFill
        }
    }
    
    private func startActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.pin.above(of: button, aligned: .center).marginBottom(10).sizeToFit()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
}

extension AuthController: AuthViewProtocol {
    
    func setPresenter(presenter: AuthPresenterProtocol, coordinator: AccountChildCoordinator) {
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
    
    func getImage() -> UIImage? {
        imageView.getImage()
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
        errorLabel.textColor = .red
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func transitionToMain() {
        dismiss(animated: true, completion: nil)
    }
}


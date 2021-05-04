import UIKit
import FirebaseAuth
import FirebaseFirestore

class AuthController: UIViewController {
    
    private var isSignIn: Bool
    
    private var emailTextField = UITextField()
    private var nameTextField = UITextField()
    private var passwordTextField1 = UITextField()
    private var passwordTextField2 = UITextField()
    private var errorLabel = UILabel()
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
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
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
    
    
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField1.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField2.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Пожалуйста, заполните все поля."
        }
        
        // Check if the password is secure
        let cleanedPassword1 = passwordTextField1.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedPassword2 = passwordTextField2.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanedPassword1 != cleanedPassword2 {
            return "Вы ввели разные пароли."
        }
        
        if cleanedPassword1.count < 6 {
            // Password isn't secure enough
            return "Пожалуйста, убедитесь, что Ваш пароль содержит хотя бы 6 символа."
        }
        return nil
    }
    

    @objc
    func buttonTapped() {
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            // There's something wrong with the fields, show error message
            showError(error!)
        }
        else {
            // Create cleaned versions of the data
            let name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField2.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                // Check for errors
                if err != nil {
                    print(err!.localizedDescription)
                    // There was an error creating the user
                    self.showError("Error creating user")
                } else {
                    // User was created successfully, now store the first name and last name
                    let db = Firestore.firestore()
                    db.collection("users").document(result!.user.uid).setData(["name" : name, "image" : "user", "id" : result!.user.uid ]) { (error) in
                        if error != nil {
                            // Show error message
                            self.showError("Error saving user data")
                        }
                    }
                    // Transition to the home screen
                    self.transitionToHome()
                }
                
            }
        }
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
        errorLabel.textColor = .red
    }
    
    func transitionToHome() {
        dismiss(animated: true, completion: nil)
    }
    
}

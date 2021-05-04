import UIKit
import PinLayout

class MainController: UIViewController {
    
    weak var coordinator: MainChildCoordinator?
    
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
        self.present(AuthController(isSignIn: true), animated: true, completion: nil)
    }
    
    @objc
    func buttonSignUpPressed() {
        self.present(AuthController(isSignIn: false), animated: true, completion: nil)
    }
    
}


import Foundation
import UIKit

protocol AuthViewPresenter {
    init(authView: AuthView)
    func setCoordinator(with coordinator: AccountChildCoordinator)

    func buttonSignInTapped()
    func buttonSignUpTapped(photo: UIImage?)
    
    func authSucceed()
}

final class AuthPresenter: AuthViewPresenter {
    
    // MARK: - Properties
    
    weak var coordinator: AccountChildCoordinator?
    
    private let authManager: AuthManagerDescription = AuthManager.shared

    private let authView: AuthView?
    
    // MARK: - Init
    
    required init(authView: AuthView) {
        self.authView = authView
    }
    
    func setCoordinator(with coordinator: AccountChildCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Handlers
    
    func buttonSignInTapped() {
        let email = authView?.getEmail() ?? ""
        let password = authView?.getPassword1() ?? ""
        
        authManager.signIn(email: email, password: password) { [weak self] (result) in
            switch result {
            case .success(_):
                self?.authSucceed()
            case .failure(let error):
                self?.authView?.showError(error.toString())
            }
            self?.authView?.stopActivityIndicator()
        }
    }
    
    func buttonSignUpTapped(photo: UIImage?) {
        let email = authView?.getEmail() ?? ""
        let name = authView?.getName() ?? ""
        let password1 = authView?.getPassword1() ?? ""
        let password2 = authView?.getPassword2() ?? ""
        
        authManager.signUp(email: email, name: name, password1: password1, password2: password2, photo: photo) { [weak self] (result) in
            switch result {
            case .success(_):
                self?.authSucceed()
            case .failure(let error):
                self?.authView?.showError(error.toString())
            }
            self?.authView?.stopActivityIndicator()
        }
    }

    func authSucceed() {
        authView?.transitionToMain()
        coordinator?.showAccount()
    }
}


import Foundation
import UIKit

protocol AuthPresenterProtocol {
    init(authView: AuthViewProtocol)
    func setCoordinator(with coordinator: AccountChildCoordinator)

    func buttonSignInTapped()
    func buttonSignUpTapped()
    
    func authSucceed()
}

final class AuthPresenter: AuthPresenterProtocol {
    
    // MARK: - Properties
    
    weak var coordinator: AccountChildCoordinator?
    
    private let authManager: AuthManagerDescription = AuthManager.shared

    private let authView: AuthViewProtocol?
    
    // MARK: - Init
    
    required init(authView: AuthViewProtocol) {
        self.authView = authView
    }
    
    func setCoordinator(with coordinator: AccountChildCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Handlers
    
    func buttonSignInTapped() {
        guard let authView = authView else { return }
        let email = authView.getEmail()
        let password = authView.getPassword1()
        
        let error = validateInput(email: email.trimmingCharacters(in: .whitespacesAndNewlines), password1: password.trimmingCharacters(in: .whitespacesAndNewlines),  isSignIn: true)
        
        if let error = error {
            authView.showError(error.toString())
            authView.stopActivityIndicator()
            return
        }
        
        authManager.signIn(email: email, password: password) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.authSucceed()
            case .failure(let error):
                self.authView?.showError(error.toString())
            }
            self.authView?.stopActivityIndicator()
        }
    }
    
    func buttonSignUpTapped() {
        guard let authView = authView else { return }
        let email = authView.getEmail()
        let name = authView.getName()
        let password1 = authView.getPassword1()
        let password2 = authView.getPassword2()
        let photo = authView.getImage()
        
        let error = validateInput(email: email, name: name, password1: password1, password2: password2, isSignIn: false)
        
        if let error = error {
            authView.showError(error.toString())
            authView.stopActivityIndicator()
            return
        }
        
        let trimedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password1.trimmingCharacters(in: .whitespacesAndNewlines)
        
        authManager.signUp(email: trimedEmail, name: trimmedName, password: trimmedPassword, photo: photo) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.authSucceed()
            case .failure(let error):
                self.authView?.showError(error.toString())
            }
            self.authView?.stopActivityIndicator()
        }
    }

    func authSucceed() {
        authView?.transitionToMain()
        coordinator?.showAccount()
    }
    
    func validateInput(email: String, name: String = "", password1: String, password2: String = "", isSignIn: Bool) -> СustomError? {
        
        // Все ли поля заполнены
        if email.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            password1.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return СustomError.emptyInput
        }
        if !isSignIn {
            if name.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                password2.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                return СustomError.emptyInput
            }
            // Проверка пароля
            let cleanedPassword1 = password1.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanedPassword2 = password2.trimmingCharacters(in: .whitespacesAndNewlines)
            if cleanedPassword1 != cleanedPassword2 {
                return СustomError.differentPasswords
            }
            if cleanedPassword1.count < 6 {
                // Небезопасный пароль
                return СustomError.incorrectPassword
            }
        }
        return nil
    }
}


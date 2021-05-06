import Foundation

protocol AuthViewPresenter {
    init(authView: AuthView)
    func setCoordinator(with coordinator: AccountChildCoordinator)

    func buttonSignTapped(isSignIn: Bool)
    func authSucceed()
}

class AuthPresenter: AuthViewPresenter {
    
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
    
    func buttonSignTapped(isSignIn: Bool) {
        let email = authView?.getEmail() ?? ""
        let name = authView?.getName() ?? ""
        let password1 = authView?.getPassword1() ?? ""
        let password2 = authView?.getPassword2() ?? ""
        if isSignIn {
            let res = authManager.signIn(email: email, password: password1) { [weak self] (result) in
                switch result {
                case .success(let userId):
                    print(userId)
                    self?.authSucceed()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            if res != nil {
                authView?.showError(res!)
                return
            }
        } else {
            let res = authManager.signUp(email: email, name: name, password1: password1, password2: password2) { [weak self] (result) in
                switch result {
                case .success(let userId):
                    print(userId)
                    self?.authSucceed()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            if res != nil {
                authView?.showError(res!)
                return
            }
        }
    }
    
    func authSucceed() {
        authView?.transitionToMain()
        coordinator?.showAccount()
    }
}

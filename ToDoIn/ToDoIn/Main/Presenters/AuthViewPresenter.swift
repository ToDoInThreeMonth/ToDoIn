import Foundation

class AuthPresenter: AuthViewPresenter {
    
    // MARK: - Properties
    
    private let authManager: AuthManagerDescription = AuthManager.shared

    private let authView: AuthView?
    
    // MARK: - Init
    
    required init(authView: AuthView) {
        self.authView = authView
    }
    
    // MARK: - Handlers
    
    func buttonSignTapped(isSignIn: Bool) -> Bool {
        let email = authView?.getEmail() ?? ""
        let name = authView?.getName() ?? ""
        let password1 = authView?.getPassword1() ?? ""
        let password2 = authView?.getPassword2() ?? ""
        if isSignIn {
            let res = authManager.signIn(email: email, password: password1)
            if res != nil {
                authView?.showError(res!)
                return false
            }
        } else {
            let res = authManager.signUp(email: email, name: name, password1: password1, password2: password2)
            if res != nil {
                authView?.showError(res!)
                return false
            }
        }
        return true
    }
}

import Foundation

protocol LoginViewPresenter {
    init(loginView: LoginView)
    func setCoordinator(with coordinator: AccountChildCoordinator)
    
    func buttonSignPressed(isSignIn: Bool)
}

final class LoginPresenter: LoginViewPresenter {
    
    // MARK: - Properties
    
    weak var coordinator: AccountChildCoordinator?
    
    private let loginView: LoginView?
    
    // MARK: - Init
    
    required init(loginView: LoginView) {
        self.loginView = loginView
    }
    
    // MARK: - Configures
    
    func setCoordinator(with coordinator: AccountChildCoordinator) {
        self.coordinator = coordinator
    }
    
    //MARK: - Handlers
    
    func buttonSignPressed(isSignIn: Bool) {
        coordinator?.showAuthController(isSignIn: isSignIn)
    }

}

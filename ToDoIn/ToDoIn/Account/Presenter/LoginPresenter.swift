import Foundation

protocol LoginPresenterProtocol {
    init(loginView: LoginViewProtocol)
    func setCoordinator(with coordinator: AccountChildCoordinator)
    
    func buttonSignPressed(isSignIn: Bool)
}

final class LoginPresenter: LoginPresenterProtocol {
    
    // MARK: - Properties
    
    weak var coordinator: AccountChildCoordinator?
    
    private let loginView: LoginViewProtocol?
    
    // MARK: - Init
    
    required init(loginView: LoginViewProtocol) {
        self.loginView = loginView
    }
    
    // MARK: - Configures
    
    func setCoordinator(with coordinator: AccountChildCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Handlers
    
    func buttonSignPressed(isSignIn: Bool) {
        coordinator?.showAuthController(isSignIn: isSignIn)
    }

}

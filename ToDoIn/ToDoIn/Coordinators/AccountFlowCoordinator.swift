import UIKit

protocol AccountChildCoordinator: ChildCoordinator {
    func showAuthController(isSignIn: Bool)
    func showAccount()
    func showLogin()
    
    func presentExitController(completion: @escaping () -> ())
    func presentErrorController(with message: String)
}

class AccountFlowCoordinator: AccountChildCoordinator {
    var navigationController: UINavigationController
    
    private let imageName: String
    private let title: String
    
    init(navigationController: UINavigationController, imageName: String, title: String) {
        self.navigationController = navigationController
        self.imageName = imageName
        self.title = title
    }
    
    func start() {
        let isSignedIn = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
        if isSignedIn {
            showAccount()
        } else {
            showLogin()
        }
    }
    
    func showAuthController(isSignIn: Bool) {
        let authController = AuthController(isSignIn: isSignIn)
        authController.setPresenter(presenter: AuthPresenter(authView: authController.self), coordinator: self)
        navigationController.viewControllers.last?.present(authController, animated: true, completion: nil)
    }
    
    func showAccount() {
        let accountController = AccountController()
        accountController.setPresenter(presenter: AccountPresenter(accountView: accountController.self), coordinator: self)
        let tabBarImage = UIImage(named: imageName)
        accountController.tabBarItem = UITabBarItem(title: title, image: tabBarImage?.withRenderingMode(.alwaysOriginal), selectedImage: tabBarImage?.withRenderingMode(.alwaysOriginal))
        navigationController.setViewControllers([accountController], animated: false)
    }
    
    func showLogin() {
        let loginController = LoginController()
        loginController.setPresenter(presenter: LoginPresenter(loginView: loginController.self), coordinator: self)
        let tabBarImage = UIImage(named: imageName)
        loginController.tabBarItem = UITabBarItem(title: title, image: tabBarImage?.withRenderingMode(.alwaysOriginal), selectedImage: tabBarImage?.withRenderingMode(.alwaysOriginal))
        navigationController.setViewControllers([loginController], animated: false)
    }
    
    func presentExitController(completion: @escaping () -> ()) {
        let alertTitle = "Выход из аккаунта"
        let alertMessage = "Вы действительно хотите выйти ?"
        guard let alertVC = AlertControllerCreator.getController(title: alertTitle, message: alertMessage, style: .alert, type: .logOut) as? ExitAlertController else { return }
        alertVC.onButtonTapped = completion
        navigationController.present(alertVC, animated: true)
    }
    
    func presentErrorController(with message: String) {
        let alertTitle = "Неожиданный сбой"
        let alertVC = AlertControllerCreator.getController(title: alertTitle, message: message, style: .alert, type: .error)
        
        navigationController.present(alertVC, animated: true)
    }
}

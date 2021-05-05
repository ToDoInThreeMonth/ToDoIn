import UIKit

protocol AccountChildCoordinator: ChildCoordinator {
    func showAuthController(isSignIn: Bool)
    func showAccount()
    func showFriendSearch()
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
        let viewController = LoginController()
        viewController.setPresenter(presenter: LoginPresenter(loginView: viewController.self), coordinator: self)
        
        let tabBarImage = UIImage(named: imageName)
        
        // Пример настройки tabBar'a
        viewController.tabBarItem = UITabBarItem(title: title, image: tabBarImage?.withRenderingMode(.alwaysOriginal), selectedImage: tabBarImage?.withRenderingMode(.alwaysOriginal))
        
        // Пример настройки viewController
        viewController.view.backgroundColor = .white
        viewController.title = title
        
        navigationController.pushViewController(viewController, animated: false)
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
    
    func showFriendSearch() {
        let friendSearchController = FriendSearchController()
        friendSearchController.setPresenter(presenter: FriendSearchPresenter(friendSearchView: friendSearchController), coordinator: self)
        navigationController.viewControllers.last?.present(friendSearchController, animated: true, completion: nil)
    }
}

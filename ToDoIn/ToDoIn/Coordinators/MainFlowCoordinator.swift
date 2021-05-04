import UIKit

protocol MainChildCoordinator: ChildCoordinator {
    func showAddSection()
    func showSignController(isSignIn: Bool)
}

class MainFlowCoordinator: MainChildCoordinator {
    var navigationController: UINavigationController
    
    private let title: String
    
    init(navigationController: UINavigationController, title: String) {
        self.navigationController = navigationController
        self.title = title
    }
    
    func start() {
        let viewController = MainController()
        viewController.setPresenter(presenter: MainPresenter(mainView: viewController.self), coordinator: self)
        
        // Пример настройки tabBar'a
        viewController.tabBarItem = UITabBarItem(title: title, image: nil, selectedImage: nil)
        
        // Пример настройки viewController
        viewController.view.backgroundColor = .white
        viewController.title = title
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
    
    func showAddSection() {}
    
    func showSignController(isSignIn: Bool) {
        navigationController.viewControllers.last?.present(AuthController(isSignIn: isSignIn), animated: true, completion: nil)
    }
}

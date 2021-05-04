import UIKit

protocol MainChildCoordinator: ChildCoordinator {
    func presentAddSectionController()
    func presentAddTaskController()
}

class MainFlowCoordinator: MainChildCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let presenter = MainPresenter(coordinator: self)
        let viewController = MainViewController(presenter: presenter)
        // Пример настройки tabBar'a
        viewController.tabBarItem = UITabBarItem(title: "Main", image: UIImage(systemName: "checkmark"), selectedImage: UIImage(systemName: "checkmark"))
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func presentAddSectionController() {}
    func presentAddTaskController() {
        let controller = UIViewController()
        navigationController.present(controller, animated: true)
    }
}

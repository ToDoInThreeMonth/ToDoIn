import UIKit

protocol MainCoordinator: class {
    var childCoordinators: [ChildCoordinator] { get set }
    var tabBarController: CustomTabBarController { get set }
    func start()
}

protocol ChildCoordinator: class {
    var navigationController: UINavigationController { get set }
    func start()
}

protocol CoordinatorOutput: UIViewController {
    var coordinator: MainChildCoordinator? { get set }
}

// Основной координатор - сборщик проекта, отвечает за UITabBarController
class AppCoordinator: MainCoordinator {
    var tabBarController: CustomTabBarController
    var childCoordinators: [ChildCoordinator]
    
    init(tabBarController: CustomTabBarController, childCoordinators: [ChildCoordinator] = []) {
        self.tabBarController = tabBarController
        self.childCoordinators = childCoordinators
    }
    
// Запускает основной координатор (отображает UITabBarController с его viewController'ами)
    func start() {
        var navigationControllers = [UINavigationController]()
        for coordinator in childCoordinators {
            navigationControllers.append(coordinator.navigationController)
            coordinator.start()
        }
        
        tabBarController.viewControllers = navigationControllers
    }
}

import UIKit

protocol MainCoordinator: class {
// Раскомментировать когда появятся стеки UINavigationController
//    var childCoordinator: [ChildCoordinator] { get set }
    var tabBarController: UITabBarController { get set }
    var viewController: UIViewController { get set }
    func start()
}

protocol ChildCoordinator: class {
    var navigationController: UINavigationController { get set }
    func start()
}

// Основной координатор - сборщик проекта, отвечает за UITabBarController
class AppCoordinator: MainCoordinator {
    var tabBarController: UITabBarController
    var viewController: UIViewController
//    var childCoordinators: [ChildCoordinator]
    
// При появлении стеков UINavigationController заменить viewController на childCoordinators: [ChildCoordinator]
    init(tabBarController: UITabBarController, viewController: UIViewController) {
        self.tabBarController = tabBarController
        self.viewController = viewController
    }
    
    func start() {
        tabBarController.viewControllers = [viewController]
        
// Раскомментировать когда появятся стеки UINavigationController
//        var navigationControllers = [UINavigationController]()
//        for coordinator in childCoordinators {
//            navigationControllers.append(coordinator.navigationController)
//            coordinator.start()
//        }
    }
}

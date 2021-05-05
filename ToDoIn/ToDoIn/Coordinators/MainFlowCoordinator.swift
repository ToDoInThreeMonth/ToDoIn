import UIKit

protocol MainChildCoordinator: ChildCoordinator {
    func presentAddSectionController()
    func presentAddTaskController(with task: Task?)
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
    
    func presentAddTaskController(with task: Task?) {
        if let task = task {
            let controller = OfflineTaskController(task: task, isChanging: true)
            navigationController.present(controller, animated: true)
        } else {
            let controller = OfflineTaskController(isChanging: false)
            navigationController.present(controller, animated: true)
        }
        
    }
}

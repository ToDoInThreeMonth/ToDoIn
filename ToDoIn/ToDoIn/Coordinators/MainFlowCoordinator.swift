import UIKit

protocol MainChildCoordinator: ChildCoordinator {
    func presentAddSectionController()
    func presentAddTaskController(with section: Int)
    func presentChangeTaskController(with task: OfflineTask, in indexPath: IndexPath)
    func showAddSectionController()
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
    
    func presentAddTaskController(with section: Int) {
        let indexPath = IndexPath(row: 0, section: section)
        let controller = OfflineTaskController(indexPath: indexPath, isChanging: false)
        navigationController.present(controller, animated: true)
    }
    
    func presentChangeTaskController(with task: OfflineTask, in indexPath: IndexPath) {
        let controller = OfflineTaskController(task: task, indexPath: indexPath, isChanging: true)
        print("Зашел")
        navigationController.present(controller, animated: true)
    }
    
    func showAddSectionController() {
        guard let controller = navigationController.viewControllers.last as? MainViewController else { return }
        let alertController = AlertControllerCreator.getController(title: "Добавление новой секции", message: "Введите название", style: .alert, type: .section, delegate: controller)
        navigationController.present(alertController, animated: true)
    }
}

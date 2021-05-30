import UIKit

protocol MainChildCoordinator: ChildCoordinator {
    func presentAddSectionController()
    func presentAddTaskController(with section: Int)
    func presentChangeTaskController(with task: OfflineTask, in indexPath: IndexPath)
    func showAddSectionController()
    func showChangeSectionController(with section: Int, output: ChangeSectionAlertDelegate)
    func presentDeleteSectionController(_ number: Int)
}

class MainFlowCoordinator: MainChildCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let presenter = MainPresenter(coordinator: self)
        let viewController = MainViewController(presenter: presenter)
        presenter.setRealmOutput(viewController)
        // Пример настройки tabBar'a
        viewController.tabBarItem = UITabBarItem(title: "Main", image: UIImage(systemName: "checkmark"), selectedImage: UIImage(systemName: "checkmark"))
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func presentAddSectionController() {}
    
    func presentAddTaskController(with section: Int) {
        guard let delegate = navigationController.viewControllers.last as? MainViewController else { return }
        let indexPath = IndexPath(row: 0, section: section)
        let presenter: OfflineTaskViewPresenter = OfflineTaskPresenter()
        let controller = OfflineTaskController(indexPath: indexPath, isChanging: false, presenter: presenter)
        
        controller.delegate = delegate
        navigationController.present(controller, animated: true)
    }
    
    func presentChangeTaskController(with task: OfflineTask, in indexPath: IndexPath) {
        let presenter: OfflineTaskViewPresenter = OfflineTaskPresenter()
        let controller = OfflineTaskController(task: task, indexPath: indexPath, isChanging: true, presenter: presenter)
        navigationController.present(controller, animated: true)
    }
    
    func showAddSectionController() {
        guard let controller = navigationController.viewControllers.last as? MainViewController,
              let alertController = AlertControllerCreator.getController(title: "Добавление новой секции", message: "Введите название", style: .alert, type: .addSection) as? AddSectionAlertController else { return }
        alertController.delegate = controller
        
        navigationController.present(alertController, animated: true)
    }
    
    func showChangeSectionController(with section: Int, output: ChangeSectionAlertDelegate) {
        guard let alertController = AlertControllerCreator.getController(title: "Изменение названия секции", message: "Введите новое название ниже и нажмите \"Сохранить\"", style: .alert, type: .changeSection) as? ChangeSectionAlertController
        else { return }
        alertController.delegate = output
        alertController.section = section
        
        navigationController.present(alertController, animated: true)
    }
    
    func presentDeleteSectionController(_ number: Int) {
        guard let controller = navigationController.viewControllers.last as? MainViewController else { return }
        guard let alertController = AlertControllerCreator.getController(title: "Уверены, что хотите удалить секцию ?", message: "Восстановить ее уже не получится", style: .alert, type: .deleteSection) as? DeleteAlertController else { return }
        alertController.delegate = controller
        alertController.section = number
        
        navigationController.present(alertController, animated: true)
    }
}

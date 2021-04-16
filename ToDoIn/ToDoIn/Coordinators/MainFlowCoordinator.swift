import UIKit

protocol MainChildCoordinator: ChildCoordinator {
    func showAddSection()
    func showAddTask(group: Group)
    func showGroupController(group: Group)
    func showSettingsGroupController(group: Group)
}

class MainFlowCoordinator: MainChildCoordinator {
    var navigationController: UINavigationController
    
    private let imageName: String
    private let title: String
    
    init(navigationController: UINavigationController, imageName: String, title: String) {
        self.navigationController = navigationController
        self.imageName = imageName
        self.title = title
    }
    
    func start() {
        let viewController: CoordinatorOutput
        
        switch title {
        case "Главная":
            viewController = ViewController()
        case "Комнаты":
            viewController = GroupsController()
        case "Аккаунт":
            viewController = ViewController()
        default:
            viewController = ViewController()
        }
        
        viewController.coordinator = self
        var tabBarImage: UIImage?
        tabBarImage = (imageName == "") ? nil : UIImage(named: imageName)
        
        // Пример настройки tabBar'a
        viewController.tabBarItem = UITabBarItem(title: title, image: tabBarImage?.withRenderingMode(.alwaysOriginal), selectedImage: tabBarImage?.withRenderingMode(.alwaysOriginal))
        
        // Пример настройки viewController
        viewController.view.backgroundColor = .white
        viewController.title = title
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
    
    func showAddSection() {}
    
    func showAddTask(group: Group) {
        navigationController.viewControllers.last?.present(AddingTaskController(group: group), animated: true, completion: nil)
    }
    
    func showGroupController(group: Group) {
        let groupController = GroupController(group: group)
        groupController.coordinator = self
        navigationController.pushViewController(groupController, animated: true)
    }
    
    func showSettingsGroupController(group: Group) {
        let settingsGroupController = GroupSettingsController(group: group)
        navigationController.pushViewController(settingsGroupController, animated: true)
    }
}

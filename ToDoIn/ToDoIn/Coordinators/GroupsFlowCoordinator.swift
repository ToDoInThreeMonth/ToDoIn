import UIKit

protocol GroupsChildCoordinator: ChildCoordinator {
    func showAddSection()
    func showTaskController(group: Group, task: Task, isChanging: Bool)
    func showGroupController(group: Group)
    func showSettingsGroupController(group: Group)
}

class GroupsFlowCoordinator: GroupsChildCoordinator {
    var navigationController: UINavigationController
    
    private let imageName: String
    private let title: String
    
    init(navigationController: UINavigationController, imageName: String, title: String) {
        self.navigationController = navigationController
        self.imageName = imageName
        self.title = title
    }
    
    func start() {
        let viewController = GroupsController()
        viewController.setPresenter(presenter: GroupsPresenter(groupsView: viewController.self), coordinator: self)
        
        let tabBarImage = (imageName == "") ? nil : UIImage(named: imageName)
        
        // Пример настройки tabBar'a
        viewController.tabBarItem = UITabBarItem(title: title, image: tabBarImage?.withRenderingMode(.alwaysOriginal), selectedImage: tabBarImage?.withRenderingMode(.alwaysOriginal))
        
        // Пример настройки viewController
        viewController.view.backgroundColor = .white
        viewController.title = title
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
    
    func showAddSection() {}
    
    func showTaskController(group: Group, task: Task, isChanging: Bool) {
        navigationController.viewControllers.last?.present(TaskController(group: group, task: task, isChanging: isChanging), animated: true, completion: nil)
    }
    
    func showGroupController(group: Group) {
        let groupController = GroupController(group: group)
        groupController.setPresenter(presenter: GroupPresenter(), coordinator: self)
        navigationController.pushViewController(groupController, animated: true)
    }
    
    func showSettingsGroupController(group: Group) {
        let settingsGroupController = GroupSettingsController(group: group)
        navigationController.pushViewController(settingsGroupController, animated: true)
    }
}


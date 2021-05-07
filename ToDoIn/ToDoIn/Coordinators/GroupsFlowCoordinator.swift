import UIKit

protocol GroupsChildCoordinator: ChildCoordinator {
    func showAddGroup()
    func showTaskController(group: Group, task: Task, users: [User], isChanging: Bool)
    func showGroupController(group: Group)
    func showSettingsGroupController(group: Group)
    func showAddUserToGroup()
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
        viewController.title = title
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
    
    func showAddGroup() {
        let addGroupController = AddGroupController()
        addGroupController.setPresenter(presenter: AddGroupPresenter(addGroupView: addGroupController.self))
        navigationController.viewControllers.last?.present(addGroupController, animated: true, completion: nil)
    }
    
    func showTaskController(group: Group, task: Task, users: [User], isChanging: Bool) {
        navigationController.viewControllers.last?.present(TaskController(group: group, task: task, users: users, isChanging: isChanging), animated: true, completion: nil)
    }
    
    func showGroupController(group: Group) {
        let groupController = GroupController(group: group)
        groupController.setPresenter(presenter: GroupPresenter(groupView: groupController.self), coordinator: self)
        navigationController.pushViewController(groupController, animated: true)
    }
    
    func showSettingsGroupController(group: Group) {
        let settingsGroupController = GroupSettingsController(group: group)
        settingsGroupController.setPresenter(presenter: GroupSettingsPresenter(groupSettingsView: settingsGroupController.self), coordinator: self)
        navigationController.pushViewController(settingsGroupController, animated: true)
    }
    
    func showAddUserToGroup() {
        let addUserToGroupController = AddUserToGroupController()
        addUserToGroupController.setPresenter(AddUserToGroupPresenter(addUserToGroupView: addUserToGroupController.self))
        navigationController.viewControllers.last?.present(addUserToGroupController, animated: true, completion: nil)
    }
}


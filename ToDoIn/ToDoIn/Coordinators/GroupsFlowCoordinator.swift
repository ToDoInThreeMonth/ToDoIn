import UIKit

protocol GroupsChildCoordinator: ChildCoordinator {
    func showAddGroup()
    func showTaskController(group: Group, task: Task, users: [User], isChanging: Bool)
    func showGroupController(group: Group)
    func showSettingsGroupController(group: Group)
    func showAddUser(to group: Group, with participants: [User])
    func presentErrorController(with message: String)
    func presentDeleteController(on viewController: UIViewController, completion: @escaping () -> ())
    func presentSignInAlert()
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
        
        let tabBarImage = imageName.isEmpty ? nil : UIImage(named: imageName)
        
        viewController.tabBarItem = UITabBarItem(title: title, image: tabBarImage?.withRenderingMode(.alwaysOriginal), selectedImage: tabBarImage?.withRenderingMode(.alwaysOriginal))
        
        viewController.title = title
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
    
    func showAddGroup() {
        let addGroupController = AddGroupController()
        let presenter = AddGroupPresenter(addGroupView: addGroupController.self)
        presenter.setDelegate(navigationController.viewControllers.last as? GroupsViewProtocol)
        addGroupController.setPresenter(presenter: presenter, coordinator: self)
        navigationController.viewControllers.last?.present(addGroupController, animated: true, completion: nil)
    }
    
    func showTaskController(group: Group, task: Task, users: [User], isChanging: Bool) {
        let taskController = TaskController(group: group, task: task, users: users, isChanging: isChanging)
        taskController.setPresenter(presenter: TaskPresenter(addingTaskView: taskController.self), coordinator: self)
        navigationController.viewControllers.last?.present(taskController, animated: true, completion: nil)
    }
    
    func showGroupController(group: Group) {
        let groupController = GroupController(group: group)
        groupController.setPresenter(presenter: GroupPresenter(groupView: groupController.self), coordinator: self)
        navigationController.pushViewController(groupController, animated: true)
    }
    
    func showSettingsGroupController(group: Group) {
        let settingsGroupController = GroupSettingsController(group: group)
        settingsGroupController.setPresenter(presenter: GroupSettingsPresenter(groupSettingsView: settingsGroupController.self, group: group), coordinator: self)
        navigationController.pushViewController(settingsGroupController, animated: true)
    }
    
    func showAddUser(to group: Group, with participants: [User]) {
        let addUserToGroupController = AddUserToGroupController()
        addUserToGroupController.setPresenter(AddUserToGroupPresenter(addUserToGroupView: addUserToGroupController.self, group: group, participants: participants), coordinator: self)
        navigationController.viewControllers.last?.present(addUserToGroupController, animated: true, completion: nil)
    }
    
    func presentErrorController(with message: String) {
        let alertTitle = "Произошла ошибка 😔"
        let alertVC = AlertControllerCreator.getController(title: alertTitle, message: message, style: .alert, type: .error)
        
        navigationController.present(alertVC, animated: true)
    }
    
    func presentDeleteController(on viewController: UIViewController, completion: @escaping () -> ()) {
        let alertTitle = "Удаление задачи"
        let alertMessage = "Вы действительно хотите удалить задачу?"
        guard let alertVC = AlertControllerCreator.getController(title: alertTitle, message: alertMessage, style: .alert, type: .logOut) as? ExitAlertController else { return }
        alertVC.onButtonTapped = completion
        viewController.present(alertVC, animated: true, completion: nil)
    }
    
    func presentSignInAlert() {
        let alertTitle = "Авторизируйтесь, чтобы создавать комнаты и участвовать в них"
        let alertVC = AlertControllerCreator.getController(title: alertTitle, message: nil, style: .alert, type: .signIn)
        navigationController.present(alertVC, animated: true)
    }
}

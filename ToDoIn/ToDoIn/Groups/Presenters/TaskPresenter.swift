import UIKit

protocol TaskPresenterProtocol {
    init(addingTaskView: TaskViewProtocol)
    func setCoordinator(with coordinator: GroupsChildCoordinator)
    
    func doneDateTapped(date: Date)
    func doneUserTapped(user: User)
    func addButtonTapped(_ isChanging: Bool, task: Task, group: Group)
    func deleteButtonTapped(task: Task, group: Group)
    
    func getUser(by userId: String, in users: [User]) -> User
    
    func showDeleteAlertController(on viewController: UIViewController, completion: @escaping () -> ())
}

final class TaskPresenter: TaskPresenterProtocol {
    
    // MARK: - Properties
    
    weak var coordinator: GroupsChildCoordinator?
    
    private let taskView: TaskViewProtocol?
    
    private let groupsManager: GroupsManagerDescription = GroupsManager.shared
        
    // MARK: - Init
    
    required init(addingTaskView: TaskViewProtocol) {
        self.taskView = addingTaskView
    }
    
    // MARK: - Configures
    
    func setCoordinator(with coordinator: GroupsChildCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Handlers

    func doneDateTapped(date: Date) {
        taskView?.setDate(with: date.toString())
    }
    
    func doneUserTapped(user: User) {
        taskView?.setUser(with: user.name)
    }
    
    func addButtonTapped(_ isChanging: Bool, task: Task, group: Group) {
        if isChanging {
            groupsManager.changeTask(task, in: group) { [weak self] (result) in
                if let result = result {
                    self?.showErrorAlertController(with: result.toString())
                }
            }
        }
        else {
            groupsManager.addTask(task, in: group)
        }
    }
    
    func deleteButtonTapped(task: Task, group: Group) {
        groupsManager.deleteTask(task, in: group)
    }

    
    func getUser(by userId: String, in users: [User]) -> User {
        for user in users {
            if userId == user.id {
                return user
            }
        }
        return User()
    }
    
    func showErrorAlertController(with message: String) {
        coordinator?.presentErrorController(with: message)
    }
    
    func showDeleteAlertController(on viewController: UIViewController, completion: @escaping () -> ()) {
        coordinator?.presentDeleteController(on: viewController, completion: completion)
    }
}
    

import Foundation

protocol TaskViewPresenter {
    init(addingTaskView: TaskView)
    func setCoordinator(with coordinator: GroupsChildCoordinator)
    
    func doneDateTapped(date: Date)
    func doneUserTapped(user: User)
    func buttonTapped(_ isChanging: Bool, task: Task, group: Group)
    func getUser(by userId: String, in users: [User]) -> User
}

class TaskPresenter: TaskViewPresenter {
    
    // MARK: - Properties
    
    weak var coordinator: GroupsChildCoordinator?
    
    private let taskView: TaskView?
    
    private let groupsManager: GroupsManagerDescription = GroupsManager.shared
        
    // MARK: - Init
    
    required init(addingTaskView: TaskView) {
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
    
    func buttonTapped(_ isChanging: Bool, task: Task, group: Group) {
        if isChanging {
            groupsManager.changeTask(task, in: group) { [weak self] (result) in
                if result != nil {
                    self?.showErrorAlertController(with: result!.toString())
                }
            }
        }
        else {
            groupsManager.addTask(task, in: group)
        }
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
}
    

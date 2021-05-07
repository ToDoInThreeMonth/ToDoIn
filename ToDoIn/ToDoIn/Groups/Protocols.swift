import Foundation

// GroupsController

protocol GroupsView: class {
    func setPresenter(presenter: GroupsViewPresenter, coordinator: GroupsChildCoordinator)
    func reloadView()
}


protocol GroupsViewPresenter {
    var groupsCount: Int { get }
    
    init(groupsView: GroupsView)
    func didLoadView()
    
    func getGroup(at index: Int) -> Group
    
    func showGroupController(group: Group)
    func setCoordinator(with coordinator: GroupsChildCoordinator)
    
    func addGroupButtonTapped()
}


// GroupController

protocol GroupView: class {
    func setPresenter(presenter: GroupViewPresenter, coordinator: GroupsChildCoordinator)
    func reloadView()
}

protocol GroupViewPresenter {
    var usersCount: Int { get }

    init(groupView: GroupView)
    func didLoadView(by userId: String)
    
    func setCoordinator(with coordinator: GroupsChildCoordinator)
    
    func getTasks(for userId: String) -> [Task]
    func getUser(by section: Int) -> User
//    func getUser(by userId: String)
    func getUsers(from userIdArray: [String])
    func getUser(by userId: String, in users: [User]) -> User


    func showSettingsGroupController()
    func showTaskCotroller(task: Task, isChanging: Bool)
}


// TaskController

protocol TaskView: class {
    func setDate(with date: String)
    func setUser(with name: String)
}


protocol TaskViewPresenter {
    init(addingTaskView: TaskView)
    func doneDateTapped(date: Date)
    func doneUserTapped(user: User)
    func buttonTapped(_ isChanging: Bool, task: Task, group: Group)
//    func getUser(by index: Int, in group: Group) -> User
    func getUser(by userId: String, in users: [User]) -> User
}


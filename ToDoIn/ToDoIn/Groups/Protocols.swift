import Foundation

// GroupsController

protocol GroupsView: class {
    func setPresenter(presenter: GroupsViewPresenter, coordinator: GroupsChildCoordinator)
    func reloadView()
}


protocol GroupsViewPresenter {
    var groupsCount: Int { get }
    init(groupsView: GroupsView)
    func getGroup(at index: Int) -> Group
    func showGroupController(group: Group)
    func setCoordinator(with coordinator: GroupsChildCoordinator)
    func didLoadView()
}


// GroupController

protocol GroupViewPresenter {
    func setCoordinator(with coordinator: GroupsChildCoordinator)
    
    func getTasks(for userId: String, from group: Group) -> [Task]
    func getUser(by index: Int, in group: Group) -> User

    func showSettingsGroupController(group: Group)
    func showTaskCotroller(group: Group, task: Task, isChanging: Bool)
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
    func getUser(by index: Int, in group: Group) -> User
}

// GroupSettingsController

protocol GroupSettingsViewPresenter {
    func groupTitleDidChange(with title: String?)
    func addUserButtonTapped()
}

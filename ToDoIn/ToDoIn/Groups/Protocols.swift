import Foundation

// GroupsController

protocol GroupsView: class {
    func setPresenter(presenter: GroupsViewPresenter, coordinator: GroupsChildCoordinator)
    func setGroups(groups: [Group])
}


protocol GroupsViewPresenter {
    init(groupsView: GroupsView)
    func getGroups()
    func showGroupController(group: Group)
    func setCoordinator(with coordinator: GroupsChildCoordinator)
}


// GroupController

protocol GroupViewPresenter {
    func setCoordinator(with coordinator: GroupsChildCoordinator)
    func getTasks(for user: User, from group: Group) -> [Task]
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
}

// GroupSettingsController

protocol GroupSettingsViewPresenter {
    func groupTitleDidChange(with title: String?)
    func addUserButtonTapped()
}

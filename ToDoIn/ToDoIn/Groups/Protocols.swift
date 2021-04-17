import Foundation

// GroupsController

protocol GroupsView: class {
    func setGroups(groups: [Group])
}


protocol GroupsViewPresenter {
    init(groupsView: GroupsView)
    func getGroups()
}


// GroupController

protocol GroupView: class {
    
}


protocol GroupViewPresenter {
    init(groupView: GroupView)
    func getTasks(for user: User, from group: Group) -> [Task] 
}


// AddingTaskController

protocol AddingTaskView: class {
    func setDate(with date: String)
    func setUser(with name: String)
}


protocol AddingTaskViewPresenter {
    init(addingTaskView: AddingTaskView)
    func doneDateTapped(date: Date)
    func doneUserTapped(user: User)
    func addButtonTapped()
}

// GroupSettingsController

protocol GroupSettingsView: class {
    
}


protocol GroupSettingsViewPresenter {
    func groupTitleDidChange(with title: String?)
    func addUserButtonTapped()
}

import Foundation

// GroupsController

protocol GroupsView: class {
    
}


protocol GroupsViewPresenter {
    init(groupsView: GroupsView)
    func getGroups() -> Groups
}


// GroupController

protocol GroupView: class {
    
}


protocol GroupViewPresenter {
    init(groupView: GroupView)
}


// AddingTaskController

protocol AddingTaskView: class {
    
}


protocol AddingTaskViewPresenter {
    init(addingTaskView: AddingTaskView)
    func addButtonTapped()
}

// GroupSettingsController

protocol GroupSettingsView: class {
    
}


protocol GroupSettingsViewPresenter {
    
}

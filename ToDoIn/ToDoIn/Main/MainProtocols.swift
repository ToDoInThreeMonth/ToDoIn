import Foundation

// MainController
protocol MainViewPresenter {
    func showAddTaskController(with indexPath: IndexPath?)
    func showAddSectionController()
}

protocol MainTableViewOutput: class {
    var tasks: [Task] { get }
    func showErrorAlertController(with message: String)
    func addTaskButtonTapped()
    func cellDidSelect(with indexPath: IndexPath)
}

protocol AuthViewOutput: class {
    func authButtonTapped()
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

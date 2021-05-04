import Foundation

// MainController
protocol MainViewPresenter {
    func showAddTaskController()
}

protocol MainTableViewOutput: class {
    var tasks: [Post] { get }
    func showErrorAlertController(with message: String)
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

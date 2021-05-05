import Foundation

// MainController
protocol MainViewPresenter {
    func showAddTaskController(with indexPath: IndexPath?) 
}

protocol MainTableViewOutput: class {
    var tasks: [Task] { get }
    func showErrorAlertController(with message: String)
    func cellDidSelect(with indexPath: IndexPath)
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

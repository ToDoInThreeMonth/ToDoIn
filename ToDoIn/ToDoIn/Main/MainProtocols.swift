import Foundation

// MainController
protocol MainViewPresenter {
    func showAddTaskController(with section: Int)
    func showChangeTaskController(with indexPath: IndexPath)
    func showAddSectionController()
    func addNewSection(with text: String)
    func taskComplete(with indexPath: IndexPath)
    func getAllSections() -> [OfflineSection]
    func getNumberOfSections() -> Int
    func getNumberOfRows(in section: Int) -> Int
    func getTask(from indexPath: IndexPath) -> OfflineTask?
    func deleteSection(_ number: Int)
}

protocol MainTableViewOutput: class {
    func showAddTaskController(with section: Int)
    func cellDidSelect(in indexPath: IndexPath)
    func doneViewTapped(with indexPath: IndexPath)
    func updateUI()
    func getAllSections() -> [OfflineSection]
    func getNumberOfSections() -> Int
    func getNumberOfRows(in section: Int) -> Int
    func getTask(from indexPath: IndexPath) -> OfflineTask?
    func deleteSection(_ number: Int)
}

protocol AuthViewOutput: class {
    func authButtonTapped()
}

protocol SectionAlertDelegate: class {
    func addNewSection(with text: String)
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

// OfflineTaskController
protocol OfflineTaskViewPresenter {
    func addTask(_ task: OfflineTask, in indexPath: IndexPath)
    func changeTask(_ task: OfflineTask, in indexPath: IndexPath)
}

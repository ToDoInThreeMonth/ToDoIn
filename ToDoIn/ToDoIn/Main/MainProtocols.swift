import Foundation

// MainController
protocol MainViewPresenter {
    func getProgress() -> Float
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
    func showDeleteSectionController(_ number: Int)
    func setRealmOutput(_ output: mainFrameRealmOutput)
}

protocol MainTableViewOutput: class {
    func getProgress() -> Float
    func showAddTaskController(with section: Int)
    func cellDidSelect(in indexPath: IndexPath)
    func doneViewTapped(with indexPath: IndexPath)
    func getAllSections() -> [OfflineSection]
    func getNumberOfSections() -> Int
    func getNumberOfRows(in section: Int) -> Int
    func getTask(from indexPath: IndexPath) -> OfflineTask?
    func showDeleteSectionController(_ number: Int)
}

protocol AuthViewOutput: class {
    func authButtonTapped()
}

protocol SectionAlertDelegate: class {
    func addNewSection(with text: String)
}

protocol DeleteAlertDelegate: class {
    func deleteSection(_ number: Int)
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

// RealmBase

protocol MainFrameRealmProtocol: class {
    func getAllSections() -> [OfflineSection]
    func getNumberOfSections() -> Int
    func getNumberOfRows(in section: Int) -> Int
    func getTask(section: Int, row: Int) -> OfflineTask?
    func addSection(_ section: OfflineSection)
    func addTask(_ task: OfflineTask, in section: Int)
    func changeTask(_ task: OfflineTask, indexPath: IndexPath)
    func changeSectionTitle(from text: String, in section: Int)
    func deleteTask(section: Int, row: Int)
    func deleteSection(section: Int)
    func setOutput(_ output: mainFrameRealmOutput)
    func taskIsComplete(in indexPath: IndexPath)
    func getProgress() -> Float
}

protocol mainFrameRealmOutput: class {
    func updateUI()
}

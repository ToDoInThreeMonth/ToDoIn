import Foundation

class MainPresenter: MainViewPresenter {
    private weak var coordinator: MainFlowCoordinator?
    
    init(coordinator: MainFlowCoordinator) {
        self.coordinator = coordinator
    }
    
    func showAddTaskController(with indexPath: IndexPath?) {
        if let indexPath = indexPath {
            let task = getTask(from: indexPath)
            coordinator?.presentAddTaskController(with: task)
        } else {
            coordinator?.presentAddTaskController(with: nil)
        }
    }
    
    func showAddSectionController() {
        coordinator?.showAddSectionController()
    }
    
    func taskComplete(with indexPath: IndexPath) {
        print("Прошло")
    }
    
    func getAllSections() -> [OfflineSection] {
        return RealmBase.getAllSections()
    }
    
    func getNumberOfSections() -> Int {
        return RealmBase.getNumberOfSections()
    }
    
    func getNumberOfRows(in section: Int) -> Int {
        return RealmBase.getNumberOfRows(in: section)
    }
    
    func getTask(from indexPath: IndexPath) -> OfflineTask? {
        return RealmBase.getTask(section: indexPath.section, row: indexPath.row)
    }
    
    func updateBase() {
        RealmBase.downloadSections()
    }
    
    func addNewSection(with text: String) {
        let section = OfflineSection()
        section.name = text
        RealmBase.addSection(section)
    }
}

import Foundation

class MainPresenter: MainViewPresenter {
    private weak var coordinator: MainFlowCoordinator?
    
    init(coordinator: MainFlowCoordinator) {
        self.coordinator = coordinator
    }
    
    func showAddTaskController(with section: Int) {
        coordinator?.presentAddTaskController(with: section)
    }
    
    func showChangeTaskController(with indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        guard let task = RealmBase.getTask(section: section, row: row) else { return }
        coordinator?.presentChangeTaskController(with: task, in: indexPath)
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
    
    func addNewSection(with text: String) {
        let section = OfflineSection()
        section.name = text
        RealmBase.addSection(section)
    }
    
    
    func deleteSection(_ number: Int) {
        RealmBase.deleteSection(section: number)
    }

}

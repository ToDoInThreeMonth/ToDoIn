import Foundation

class MainPresenter: MainViewPresenter {
    private weak var coordinator: MainFlowCoordinator?
    private var dataBase: MainFrameRealmProtocol?
    
    init(coordinator: MainFlowCoordinator) {
        self.coordinator = coordinator
    }
    
    func setRealmOutput(_ output: mainFrameRealmOutput) {
        let base = MainFrameRealm(output: output)
        dataBase = base
    }
    
    func showAddTaskController(with section: Int) {
        coordinator?.presentAddTaskController(with: section)
    }
    
    func showChangeTaskController(with indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        guard let task = dataBase?.getTask(section: section, row: row) else { return }
        coordinator?.presentChangeTaskController(with: task, in: indexPath)
    }
    
    func showAddSectionController() {
        coordinator?.showAddSectionController()
    }
    
    func taskComplete(with indexPath: IndexPath) {
        print("Прошло")
    }
    
    func getAllSections() -> [OfflineSection] {
        guard let dataBase = dataBase else { return [] }
        return dataBase.getAllSections()
    }
    
    func getNumberOfSections() -> Int {
        guard let dataBase = dataBase else { return 0 }
        return dataBase.getNumberOfSections()
    }
    
    func getNumberOfRows(in section: Int) -> Int {
        guard let dataBase = dataBase else { return 0 }
        return dataBase.getNumberOfRows(in: section)
    }
    
    func getTask(from indexPath: IndexPath) -> OfflineTask? {
        guard let dataBase = dataBase else { return nil }
        return dataBase.getTask(section: indexPath.section, row: indexPath.row)
    }
    
    func addNewSection(with text: String) {
        guard let dataBase = dataBase else { return }
        let section = OfflineSection()
        section.name = text
        dataBase.addSection(section)
    }
    
    
    func deleteSection(_ number: Int) {
        guard let dataBase = dataBase else { return }
        dataBase.deleteSection(section: number)
    }
    
    func showDeleteSectionController(_ number: Int) {
        coordinator?.presentDeleteSectionController(number)
    }

}

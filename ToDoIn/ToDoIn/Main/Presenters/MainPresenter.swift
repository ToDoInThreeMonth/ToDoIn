import Foundation

class MainPresenter: MainViewPresenter {
    private let realmBase: MainFrameRealmProtocol = MainFrameRealm.shared
    private weak var coordinator: MainFlowCoordinator?
    
    init(coordinator: MainFlowCoordinator) {
        self.coordinator = coordinator
    }
    
    func setRealmOutput(_ output: mainFrameRealmOutput) {
        realmBase.setOutput(output)
    }
    
    func showAddTaskController(with section: Int) {
        coordinator?.presentAddTaskController(with: section)
    }
    
    func showChangeTaskController(with indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        guard let task = realmBase.getTask(section: section, row: row) else { return }
        coordinator?.presentChangeTaskController(with: task, in: indexPath)
    }
    
    func showAddSectionController() {
        coordinator?.showAddSectionController()
    }
    
    func taskComplete(with indexPath: IndexPath) {
        print("Прошло")
    }
    
    func getAllSections() -> [OfflineSection] {
        return realmBase.getAllSections()
    }
    
    func getNumberOfSections() -> Int {
        return realmBase.getNumberOfSections()
    }
    
    func getNumberOfRows(in section: Int) -> Int {
        return realmBase.getNumberOfRows(in: section)
    }
    
    func getTask(from indexPath: IndexPath) -> OfflineTask? {
        return realmBase.getTask(section: indexPath.section, row: indexPath.row)
    }
    
    func addNewSection(with text: String) {
        let section = OfflineSection()
        section.name = text
        realmBase.addSection(section)
    }
    
    
    func deleteSection(_ number: Int) {
        realmBase.deleteSection(section: number)
    }
    
    func showDeleteSectionController(_ number: Int) {
        coordinator?.presentDeleteSectionController(number)
    }

}

import Foundation

protocol MainPresenterProtocol {
    func showChangeSectionController(with section: Int)
    func getProgress() -> Float
    func showAddTaskController(with section: Int)
    func showChangeTaskController(with indexPath: IndexPath, isArchive: Bool)
    func showAddSectionController()
    func addNewSection(with text: String)
    func taskComplete(with indexPath: IndexPath)
    func getAllSections() -> [OfflineSection]
    func getNumberOfSections() -> Int
    func getNumberOfRows(in section: Int, isArchive: Bool) -> Int
    func getTask(from indexPath: IndexPath, isArchive: Bool) -> OfflineTask?
    func deleteSection(_ number: Int)
    func showDeleteSectionController(_ number: Int)
    func setRealmOutput(_ output: mainFrameRealmOutput)
    func getArchiveSection() -> ArchiveSection?
    func deleteTask(section: Int, row: Int, isArchive: Bool)
}

class MainPresenter: MainPresenterProtocol {
    private let realmBase: MainFrameRealmProtocol = MainFrameRealm.shared
    private weak var coordinator: MainFlowCoordinator?
    
    init(coordinator: MainFlowCoordinator) {
        self.coordinator = coordinator
    }
    
    func deleteTask(section: Int, row: Int, isArchive: Bool) {
        realmBase.deleteTask(section: section, row: row, isArchive: isArchive)
    }
    
    func getArchiveSection() -> ArchiveSection? {
        return realmBase.getArchiveSection()
    }
    
    func setRealmOutput(_ output: mainFrameRealmOutput) {
        realmBase.setOutput(output)
    }
    
    func showAddTaskController(with section: Int) {
        coordinator?.presentAddTaskController(with: section)
    }
    
    func showChangeTaskController(with indexPath: IndexPath, isArchive: Bool) {
        let section = indexPath.section
        let row = indexPath.row
        guard let task = realmBase.getTask(section: section, row: row, isArchive: isArchive) else { return }
        coordinator?.presentChangeTaskController(with: task, in: indexPath, isArchive: isArchive)
    }
    
    func showAddSectionController() {
        coordinator?.showAddSectionController()
    }
    
    func taskComplete(with indexPath: IndexPath) {
        realmBase.taskIsComplete(in: indexPath)
    }
    
    func getAllSections() -> [OfflineSection] {
        return realmBase.getOfflineSections()
    }
    
    func getNumberOfSections() -> Int {
        return realmBase.getNumberOfSections()
    }
    
    func getNumberOfRows(in section: Int, isArchive: Bool) -> Int {
        return realmBase.getNumberOfRows(in: section, isArchive: isArchive)
    }
    
    func getTask(from indexPath: IndexPath, isArchive: Bool) -> OfflineTask? {
        return realmBase.getTask(section: indexPath.section, row: indexPath.row, isArchive: isArchive)
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

    func getProgress() -> Float {
        return realmBase.getProgress()
    }
    
    func showChangeSectionController(with section: Int) {
        coordinator?.showChangeSectionController(with: section, output: self)
    }
}

extension MainPresenter: ChangeSectionAlertDelegate {
    func changeSection(with number: Int, text: String) {
        realmBase.changeSectionTitle(from: text, in: number)
    }
}

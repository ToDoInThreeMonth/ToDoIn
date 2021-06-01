import Foundation

// MainController

protocol AuthViewOutput: class {
    func authButtonTapped()
}

protocol AddSectionAlertDelegate: class {
    func addNewSection(with text: String)
}

protocol ChangeSectionAlertDelegate: class {
    func changeSection(with number: Int, text: String)
}

protocol DeleteAlertDelegate: class {
    func deleteSection(_ number: Int)
}

// RealmBase
protocol MainFrameRealmProtocol: class {
    func getOfflineSections() -> [OfflineSection]
    func getArchiveSection() -> ArchiveSection?
    func getNumberOfSections() -> Int
    func getNumberOfRows(in section: Int, isArchive: Bool) -> Int
    func getTask(section: Int, row: Int, isArchive: Bool) -> OfflineTask?
    func addSection(_ section: OfflineSection)
    func addTask(_ task: OfflineTask, in section: Int)
    func changeTask(_ task: OfflineTask, indexPath: IndexPath)
    func changeSectionTitle(from text: String, in section: Int)
    func deleteTask(section: Int, row: Int, isArchive: Bool)
    func deleteSection(section: Int)
    func setOutput(_ output: mainFrameRealmOutput)
    func taskIsComplete(in indexPath: IndexPath)
    func getProgress() -> Float
}

protocol mainFrameRealmOutput: class {
    func updateUI()
}

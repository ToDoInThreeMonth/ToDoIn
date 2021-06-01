import UIKit

protocol OfflineTaskViewPresenter {
    func setCoordinator(with coordinator: MainChildCoordinator)
    
    func addTask(_ task: OfflineTask, in indexPath: IndexPath)
    func changeTask(_ task: OfflineTask, in indexPath: IndexPath)
    func taskIsComplete(in indexPath: IndexPath)
    func doneDateTapped(date: Date)
    func deleteButtonTapped(section: Int, row: Int, isArchive: Bool)
    
    func showDeleteAlertController(on viewController: UIViewController, completion: @escaping () -> ())
}

final class OfflineTaskPresenter: OfflineTaskViewPresenter {
    
    // MARK: - Properties
    
    weak var coordinator: MainChildCoordinator?
    
    private let taskView: OfflineTaskView?
    
    private var realmBase: MainFrameRealmProtocol = MainFrameRealm.shared
    
    // MARK: - Init
    
    required init(taskView: OfflineTaskView) {
        self.taskView = taskView
    }
    
    // MARK: - Configures
    
    func setCoordinator(with coordinator: MainChildCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Handlers
    
    func addTask(_ task: OfflineTask, in indexPath: IndexPath) {
        let section = indexPath.section
        realmBase.addTask(task, in: section)
    }
    
    func changeTask(_ task: OfflineTask, in indexPath: IndexPath) {
        realmBase.changeTask(task, indexPath: indexPath)
    }
    
    func taskIsComplete(in indexPath: IndexPath) {
        realmBase.taskIsComplete(in: indexPath)
    }
    
    func doneDateTapped(date: Date) {
        taskView?.setDate(with: date.toString())
    }
    
    func deleteButtonTapped(section: Int, row: Int, isArchive: Bool) {
        realmBase.deleteTask(section: section, row: row, isArchive: isArchive)
    }
    
    func showDeleteAlertController(on viewController: UIViewController, completion: @escaping () -> ()) {
        coordinator?.presentDeleteTaskController(on: viewController, completion: completion)
    }
}

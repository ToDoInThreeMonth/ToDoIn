import Foundation

class MainPresenter: MainViewPresenter {
    private weak var coordinator: MainFlowCoordinator?
    
    init(coordinator: MainFlowCoordinator) {
        self.coordinator = coordinator
    }
    
    func showAddTaskController(with indexPath: IndexPath?) {
        if let indexPath = indexPath {
            let task = OfflineTasks.sections[indexPath.section].tasks[indexPath.row]
            coordinator?.presentAddTaskController(with: task)
        } else {
            coordinator?.presentAddTaskController(with: nil)
        }
    }
    
    func showAddSectionController() {
        coordinator?.showAddSectionController()
    }
}

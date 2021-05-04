import Foundation

class MainPresenter: MainViewPresenter {
    private weak var coordinator: MainFlowCoordinator?
    
    init(coordinator: MainFlowCoordinator) {
        self.coordinator = coordinator
    }
    
    func showAddTaskController() {
        coordinator?.presentAddTaskController()
    }
}

import Foundation

class GroupPresenter: GroupViewPresenter {

    // MARK: - Properties
    
    weak var coordinator: GroupsChildCoordinator?
    
    private let groupsService = GroupsService()
    
    // MARK: - Configures
    
    func setCoordinator(with coordinator: GroupsChildCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Handlers
    
    func getTasks(for user: User, from group: Group) -> [Task] {
        return groupsService.getTasks(for: user, from: group)
    }
    
    func showTaskCotroller(group: Group, task: Task, isChanging: Bool) {
        coordinator?.showTaskController(group: group, task: task, isChanging: isChanging)
    }
    
    func showSettingsGroupController(group: Group) {
        coordinator?.showSettingsGroupController(group: group)
    }
    
}

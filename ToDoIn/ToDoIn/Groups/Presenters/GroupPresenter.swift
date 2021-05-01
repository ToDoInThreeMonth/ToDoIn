import UIKit

class GroupPresenter: GroupViewPresenter {

    // MARK: - Properties
    
    weak var coordinator: GroupsChildCoordinator?
    
    private let groupsManager: GroupsManagerDescription = GroupsManager.shared
    
//    private let groupsService = GroupsService()
    
    // MARK: - Configures
    
    func setCoordinator(with coordinator: GroupsChildCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Handlers
    
    func getTasks(for userId: String, from group: Group) -> [Task] {
        return groupsManager.getTasks(for: userId, from: group)
    }
    
    func getUser(by index: Int, in group: Group) -> User {
        return groupsManager.getUser(by: group.users[index])
    }
    
    func showTaskCotroller(group: Group, task: Task, isChanging: Bool) {
        coordinator?.showTaskController(group: group, task: task, isChanging: isChanging)
    }
    
    func showSettingsGroupController(group: Group) {
        coordinator?.showSettingsGroupController(group: group)
    }
}

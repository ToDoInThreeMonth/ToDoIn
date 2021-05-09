import Foundation

class GroupsPresenter: GroupsViewPresenter {
    
    // MARK: - Properties
    
    weak var coordinator: GroupsChildCoordinator?
    
    private let groupsService = GroupsService()
    private let groupsView: GroupsView?
    
    // MARK: - Init
    
    required init(groupsView: GroupsView) {
        self.groupsView = groupsView
    }
    
    // MARK: - Configures
    
    func setCoordinator(with coordinator: GroupsChildCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Handlers

    func getGroups() {
        let groups = groupsService.getGroups()
        groupsView?.setGroups(groups: groups)
    }
    
    func showGroupController(group: Group) {
        coordinator?.showGroupController(group: group)
    }
}

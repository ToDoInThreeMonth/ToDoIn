import Foundation

class GroupsPresenter: GroupsViewPresenter {
    
    // MARK: - Properties
    
    weak var coordinator: GroupsChildCoordinator?
    
    private let groupsView: GroupsView?
    
    private let groupsManager: GroupsManagerDescription = GroupsManager.shared
    private let authManager: AuthManagerDescription = AuthManager.shared
    
    private var groups: [Group] = []
    
    var groupsCount: Int {
        groups.count
    }
    
    // MARK: - Init
    
    required init(groupsView: GroupsView) {
        self.groupsView = groupsView
    }
    
    // MARK: - Configures
    
    func setCoordinator(with coordinator: GroupsChildCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Handlers

    func getGroup(at index: Int) -> Group {
        return groups[index]
    }
    
    func showGroupController(group: Group) {
        coordinator?.showGroupController(group: group)
    }
    
    func addGroupButtonTapped() {
        if authManager.isSignedIn() {
            coordinator?.showAddGroup()
        }
    }
    
    func didLoadView() {
        groupsManager.observeGroups { [weak self] (result) in
            switch result {
            case .success(let groups):
                self?.groups = groups.map { $0 }
                self?.groupsView?.reloadView()
            case .failure(let error):
                self?.groups.removeAll()
                self?.groupsView?.reloadView()
                print(error.localizedDescription)
            }
        }
    }
}

import Foundation

protocol GroupSettingsViewPresenter {
    func setCoordinator(with coordinator: GroupsChildCoordinator)
    func getUsers(from userIdArray: [String])
    func groupTitleDidChange(with title: String?)
    func addUserButtonTapped()
    func getUser(by section: Int) -> User
}

class GroupSettingsPresenter: GroupSettingsViewPresenter {
    
    // MARK: - Properties
    
    weak var coordinator: GroupsChildCoordinator?
    
    private let groupsManager: GroupsManagerDescription = GroupsManager.shared
    
    private let groupSettingsView: GroupSettingsView?

    private var users: [User] = []
    
    var usersCount: Int {
        users.count
    }
    
    // MARK: - Init
    
    required init(groupSettingsView: GroupSettingsView) {
        self.groupSettingsView = groupSettingsView
    }
    
    func setCoordinator(with coordinator: GroupsChildCoordinator) {
        self.coordinator = coordinator
    }

    // MARK: - Handlers
    
    func getUsers(from userIdArray: [String]) {
//        users.removeAll()
        for userId in userIdArray {
            groupsManager.getUser(userId: userId) { [weak self] (result) in
                switch result {
                case .success(let user):
                    self?.users.append(user)
                    self?.groupSettingsView?.reloadView()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getUser(by section: Int) -> User {
        return section < users.count ? users[section] : User()
    }

    func groupTitleDidChange(with title: String?) {
        // изменение названия комнаты 
    }
    
    func addUserButtonTapped() {
        // добавление нового участника в комнату
        coordinator?.showAddUserToGroup(with: users)
    }
    
}

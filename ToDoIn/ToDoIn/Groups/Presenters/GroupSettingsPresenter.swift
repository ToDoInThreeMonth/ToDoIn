import Foundation

class GroupSettingsPresenter: GroupSettingsViewPresenter {
    
    // MARK: - Properties
    
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

    // MARK: - Handlers
    
    func getUsers(from userIdArray: [String]) {
        for userId in userIdArray {
            groupsManager.getUser(by: userId) { [weak self] (result) in
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
    }
    
}

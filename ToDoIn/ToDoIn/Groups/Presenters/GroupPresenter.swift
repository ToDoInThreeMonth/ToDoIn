import Foundation

protocol GroupPresenterProtocol {
    var usersCount: Int { get }

    init(groupView: GroupViewProtocol)
    func didLoadView(by userId: String)
    func setCoordinator(with coordinator: GroupsChildCoordinator)
    
    func getTasks(for userId: String) -> [Task]
    func getUser(by section: Int) -> User
    func getUsers(from userIdArray: [String])
    func getUser(by userId: String, in users: [User]) -> User

    func showSettingsGroupController()
    func showTaskCotroller(task: Task, isChanging: Bool)
    func showErrorAlertController(with message: String)
}

final class GroupPresenter: GroupPresenterProtocol {

    // MARK: - Properties
    
    weak var coordinator: GroupsChildCoordinator?
    
    private let groupsManager: GroupsManagerDescription = GroupsManager.shared
    
    private let groupView: GroupViewProtocol?
        
    private var group = Group()
    private var users: [User] = []
    
    var usersCount: Int {
        users.count
    }
    
    // MARK: - Init
    
    required init(groupView: GroupViewProtocol) {
        self.groupView = groupView
    }
    
    // MARK: - Configures
    
    func setCoordinator(with coordinator: GroupsChildCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Handlers
    
    func didLoadView(by userId: String) {
        groupsManager.observeGroup(by: userId) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let group):
                self.group = group
                self.getUsers(from: group.users)
            case .failure(let error):
                self.showErrorAlertController(with: error.toString())
            }
        }
    }
    
    func getTasks(for userId: String) -> [Task] {
        return groupsManager.getTasks(for: userId, from: group)
    }
    
    func getUsers(from userIdArray: [String]) {
        users.removeAll()
        for userId in userIdArray {
            groupsManager.getUser(userId: userId) { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    self.users.append(user)
                    self.groupView?.reloadView()
                case .failure(let error):
                    self.showErrorAlertController(with: error.toString())
                }
            }
        }
    }
    
    func getUser(by section: Int) -> User {
        return section < users.count ? users[section] : User()
    }
    
    func getUser(by userId: String, in users: [User]) -> User {
        for user in users {
            if userId.elementsEqual(user.id) {
                return user
            }
        }
        return User()
    }
    
    func showTaskCotroller(task: Task, isChanging: Bool) {
        coordinator?.showTaskController(group: group, task: task, users: users, isChanging: isChanging)
    }
    
    func showSettingsGroupController() {
        coordinator?.showSettingsGroupController(group: group)
    }
    
    func showErrorAlertController(with message: String) {
        coordinator?.presentErrorController(with: message)
    }
}

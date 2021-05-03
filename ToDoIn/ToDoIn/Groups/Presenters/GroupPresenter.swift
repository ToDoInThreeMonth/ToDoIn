import UIKit

class GroupPresenter: GroupViewPresenter {

    // MARK: - Properties
    
    weak var coordinator: GroupsChildCoordinator?
    
    private let groupsManager: GroupsManagerDescription = GroupsManager.shared
    
    private let groupView: GroupView?
    
//    private let groupsService = GroupsService()
    
    private var group = Group()
    
    private var users: [User] = []
    
    var usersCount: Int {
        users.count
    }
    
    // MARK: - Init
    
    required init(groupView: GroupView) {
        self.groupView = groupView
    }
    
    // MARK: - Configures
    
    func setCoordinator(with coordinator: GroupsChildCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Handlers
    
    func didLoadView(by userId: String) {
        groupsManager.observeGroup(by: userId) { [weak self] (result) in
            switch result {
            case .success(let group):
                self?.group = group
                self?.groupView?.reloadView()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getTasks(for userId: String) -> [Task] {
        return groupsManager.getTasks(for: userId, from: group)
    }
    
//    func getUser(by userId: String) {
//        groupsManager.getUser(by: userId) { [weak self] (result) in
//            switch result {
//            case .success(let user):
//                self?.users.append(user)
//                self?.groupView?.reloadView()
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    func getUsers(from userIdArray: [String]) {
        for userId in userIdArray {
            groupsManager.getUser(by: userId) { [weak self] (result) in
                switch result {
                case .success(let user):
                    self?.users.append(user)
                    self?.groupView?.reloadView()
                case .failure(let error):
                    print(error.localizedDescription)
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
}

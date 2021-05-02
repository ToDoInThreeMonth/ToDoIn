import UIKit

class GroupPresenter: GroupViewPresenter {

    // MARK: - Properties
    
    weak var coordinator: GroupsChildCoordinator?
    
    private let groupsManager: GroupsManagerDescription = GroupsManager.shared
    
    private let groupView: GroupView?
    
//    private let groupsService = GroupsService()
    
    private var users: [User] = []
    
    // MARK: - Init
    
    required init(groupView: GroupView) {
        self.groupView = groupView
    }
    
    // MARK: - Configures
    
    func setCoordinator(with coordinator: GroupsChildCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Handlers
    
    func getTasks(for userId: String, from group: Group) -> [Task] {
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
    
    func showTaskCotroller(group: Group, task: Task, isChanging: Bool) {
        coordinator?.showTaskController(group: group, task: task, isChanging: isChanging)
    }
    
    func showSettingsGroupController(group: Group) {
        coordinator?.showSettingsGroupController(group: group)
    }
}

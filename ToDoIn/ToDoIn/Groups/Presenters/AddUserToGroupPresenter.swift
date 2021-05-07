import Foundation

protocol AddUserToGroupViewPresenter {
    func didLoadView()
    
    func getFriend(by index: Int) -> User?
    func getAllFriends() -> [User]
}

class AddUserToGroupPresenter: AddUserToGroupViewPresenter {
    
    // MARK: - Preperties
    
    private let addUserToGroupView: FriendsTableViewOutput?
    
    private let groupsManager: GroupsManagerDescription = GroupsManager.shared

    private var user = User()
    private var friends = [User]()
    
    // MARK: - Init
    
    init(addUserToGroupView: FriendsTableViewOutput) {
        self.addUserToGroupView = addUserToGroupView
    }
    
    // MARK: - Handlers
    
    func didLoadView() {
        groupsManager.observeUser { [weak self] (result) in
            switch result {
            case .success(let user):
                print(user)
                self?.user = user
                self?.getFriends(for: user)
                self?.addUserToGroupView?.reloadView()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getFriends(for user: User) {
        friends = []
        for friendId in user.friends {
            groupsManager.getUser(userId: friendId) { [weak self] (result) in
                switch result {
                case .success(let user):
                    print(user)
                    self?.friends.append(user)
                    self?.addUserToGroupView?.reloadView()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getAllFriends() -> [User] {
        friends
    }
    
    func getFriend(by index: Int) -> User? {
        if index < friends.count {
            return friends[index]
        }
        return nil
    }
    
}

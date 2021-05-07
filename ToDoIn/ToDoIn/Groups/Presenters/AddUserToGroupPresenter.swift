import Foundation

protocol AddUserToGroupViewPresenter {
    func didLoadView()
    
    func addButtonTapped(selectedUsers: [IndexPath])
    
    func getFriend(by index: Int) -> User?
    func getAllFriends() -> [User]
}

class AddUserToGroupPresenter: AddUserToGroupViewPresenter {
    
    // MARK: - Preperties
    
    private let addUserToGroupView: FriendsTableViewOutput?
    
    private let groupsManager: GroupsManagerDescription = GroupsManager.shared

    private var group: Group
    private var user = User()
    private var participants = [User]()
    private var otherFriends = [User]()
    
    // MARK: - Init
    
    init(addUserToGroupView: FriendsTableViewOutput, group: Group, participants: [User]) {
        self.addUserToGroupView = addUserToGroupView
        self.participants = participants
        self.group = group
    }
    
    // MARK: - Handlers
    
    func didLoadView() {
        groupsManager.observeUser(by: nil) { [weak self] (result) in
            switch result {
            case .success(let user):
                self?.user = user
                self?.getFriends(for: user)
                self?.addUserToGroupView?.reloadView()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getFriends(for user: User) {
        otherFriends = []
        for friendId in user.friends {
            groupsManager.getUser(userId: friendId) { [weak self] (result) in
                switch result {
                case .success(let user):
                    if !(self?.participants.contains(user) ?? true) {
                        self?.otherFriends.append(user)
                        self?.addUserToGroupView?.reloadView()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func addButtonTapped(selectedUsers: [IndexPath]) {
        for index in selectedUsers {
            groupsManager.addUser(otherFriends[index.row], to: group)
        }
    }
    
    func getAllFriends() -> [User] {
        otherFriends
    }
    
    func getFriend(by index: Int) -> User? {
        if index < otherFriends.count {
            return otherFriends[index]
        }
        return nil
    }
    
}

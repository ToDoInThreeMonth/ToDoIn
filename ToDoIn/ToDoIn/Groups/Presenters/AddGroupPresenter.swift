import Foundation

protocol AddGroupViewPresenter {
    func didLoadView()
    
    func getAllFriends() -> [User]
    func getFriend(by index: Int) -> User?
    
    func addButtonTapped()
}

class AddGroupPresenter: AddGroupViewPresenter {
    
    // MARK: - Properties
    
    private let addGroupView: FriendsTableViewOutput?
    
    private let groupsManager: GroupsManagerDescription = GroupsManager.shared
    
    private var user = User()
    private var friends = [User]()
        
    // MARK: - Init
    
    required init(addGroupView: FriendsTableViewOutput) {
        self.addGroupView = addGroupView
    }
    
    // MARK: - Handlers
    
    func didLoadView() {
        groupsManager.observeUser { [weak self] (result) in
            switch result {
            case .success(let user):
                self?.user = user
                self?.getFriends(for: user)
                self?.addGroupView?.reloadView()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getFriends(for user: User) {
        friends = []
        for friendId in user.friends {
            groupsManager.getUser(by: friendId) { [weak self] (result) in
                switch result {
                case .success(let user):
                    self?.friends.append(user)
                    self?.addGroupView?.reloadView()
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
    
    func addButtonTapped() {
        print(#function)
    }
}

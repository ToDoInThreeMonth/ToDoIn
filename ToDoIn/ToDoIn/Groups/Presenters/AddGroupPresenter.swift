import Foundation
import UIKit

protocol AddGroupViewPresenter {
    func didLoadView()
    
    func getAllFriends() -> [User]
    func getFriend(by index: Int) -> User?
    
    func addButtonTapped(title: String, selectedUsers: [IndexPath], photo: UIImage?)
}

class AddGroupPresenter: AddGroupViewPresenter {
    
    // MARK: - Properties
    
    private let addGroupView: FriendsTableViewOutput?
    
    private let groupsManager: GroupsManagerDescription = GroupsManager.shared
    private let authManager: AuthManagerDescription = AuthManager.shared
    
    private var user = User()
    private var friends = [User]()
        
    // MARK: - Init
    
    required init(addGroupView: FriendsTableViewOutput) {
        self.addGroupView = addGroupView
    }
    
    // MARK: - Handlers
    
    func didLoadView() {
        groupsManager.observeUser(by: nil) { [weak self] (result) in
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
            groupsManager.getUser(userId: friendId) { [weak self] (result) in
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
    
    func addButtonTapped(title: String, selectedUsers: [IndexPath], photo: UIImage?) {
        guard let currentUserId = authManager.getCurrentUserId() else {
            return
        }
        var usersId = [currentUserId]
        for ind in selectedUsers {
            guard let userId = self.getFriend(by: ind.row)?.id else {
                continue
            }
            usersId.append(userId)
        }
        groupsManager.addGroup(title: title, users: usersId, photo: photo)
    }
}

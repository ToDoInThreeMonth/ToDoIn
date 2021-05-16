import Foundation
import UIKit

protocol AddUserToGroupViewPresenter {
    func setCoordinator(with coordinator: GroupsChildCoordinator)
    func didLoadView()
    
    func addButtonTapped(selectedUsers: [IndexPath])
    
    func getFriend(by index: Int) -> User?
    func getAllFriends() -> [User]
    
    func loadImage(url: String, completion: @escaping (UIImage) -> Void)
    
    func showErrorAlertController(with message: String)
}

final class AddUserToGroupPresenter: AddUserToGroupViewPresenter {
    
    // MARK: - Preperties
    
    private weak var coordinator: GroupsChildCoordinator?
    
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
    
    func setCoordinator(with coordinator: GroupsChildCoordinator) {
        self.coordinator = coordinator
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
                self?.addUserToGroupView?.showErrorAlertController(with: error.toString())
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
                    self?.addUserToGroupView?.showErrorAlertController(with: error.toString())
                }
            }
        }
    }
    
    func addButtonTapped(selectedUsers: [IndexPath]) {
        var users = [User]()
        for index in selectedUsers {
            users.append(otherFriends[index.row])
        }
        groupsManager.addUsers(users, to: group)
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
    
    func loadImage(url: String, completion: @escaping (UIImage) -> Void) {
        ImagesManager.loadPhotoFromStorage(url: url) { (result) in
            switch result {
            case .success(let resImage):
                completion(resImage)
            case .failure(_):
                completion(UIImage(named: "default") ?? UIImage())
            }
        }
    }
    
    func showErrorAlertController(with message: String) {
        coordinator?.presentErrorController(with: message)
    }
    
}

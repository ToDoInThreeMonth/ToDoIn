import UIKit

protocol AccountViewPresenter {
    func didLoadView()
    func setCoordinator(with coordinator: AccountChildCoordinator)
    
    func showExitAlertController(completion: @escaping () -> ())
    func showErrorAlertController(with message: String)
    func addFriendButtonTapped()
    
    func toggleNotifications() -> UIImage?
    func getFriends(from text: String) -> [User]
    func getAllFriends() -> [User]
    func getFriend(by index: Int) -> User?
    func getFriends(for user: User)
}

class AccountPresenter: AccountViewPresenter {
    
    // MARK: - Properties
    
    private weak var coordinator: AccountChildCoordinator?
    
    private let groupsManager: GroupsManagerDescription = GroupsManager.shared
    
    private let accountView: FriendsTableViewOutput?
    
    private var isNotificationTurnedOn = false
    
    private var user = User()
    private var friends = [User]()
    
    // MARK: - Init
    
    init(accountView: FriendsTableViewOutput) {
        self.accountView = accountView
    }
    
    func setCoordinator(with coordinator: AccountChildCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Handlers
    
    func didLoadView() {
        groupsManager.observeUser { [weak self] (result) in
            switch result {
            case .success(let user):
                self?.user = user
                self?.getFriends(for: user)
                self?.accountView?.setUp(with: user)
                self?.accountView?.reloadView()
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
                    self?.accountView?.reloadView()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func showExitAlertController(completion: @escaping () -> ()) {
        coordinator?.presentExitController(completion: completion)
    }
    
    func toggleNotifications() -> UIImage? {
        // Включение/Выключение уведомлений
        isNotificationTurnedOn.toggle()
        if isNotificationTurnedOn {
            return UIImage(named: "turnedNotification")?.withRenderingMode(.alwaysOriginal)
        } else {
            return UIImage(named: "offNotification")?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    func getFriends(from text: String) -> [User] {
        // Реализация поиска
        return []
    }
    
    func showErrorAlertController(with message: String) {
        coordinator?.presentErrorController(with: message)
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
    
    func addFriendButtonTapped() {
        coordinator?.showFriendSearch()
    }
    
}

//import Foundation
//
//protocol AccountViewPresenter {
//    init(accountView: AccountView)
//    func setCoordinator(with coordinator: AccountChildCoordinator)
//
//    func addFriendsButtonTapped()
//}
//
//class AccountPresenter: AccountViewPresenter {
//
//    // MARK: - Properties
//
//    weak var coordinator: AccountChildCoordinator?
//
//    private let accountView: AccountView?
//
//    // MARK: - Init
//
//    required init(accountView: AccountView) {
//        self.accountView = accountView
//    }
//
//    func setCoordinator(with coordinator: AccountChildCoordinator) {
//        self.coordinator = coordinator
//    }
//
//    // MARK: - Configures
//
//    func addFriendsButtonTapped() {
//        coordinator?.showFriendSearch()
//    }
//}

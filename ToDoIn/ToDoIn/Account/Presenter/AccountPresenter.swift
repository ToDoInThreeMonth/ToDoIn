import UIKit

protocol AccountPresenterProtocol {
    func didLoadView()
    func setCoordinator(with coordinator: AccountChildCoordinator)
    
    func showExitAlertController(completion: @escaping () -> ())
    func showErrorAlertController(with message: String)
    
    func exitButtonTapped()
    func deleteTapped(for friend: User)
    func imageIsChanged(with image: UIImage?)
    func userNameDidChange(with name: String)
        
    func getAllFriends() -> [User]
    func getFriend(by index: Int) -> User?
    func getFriends(for user: User)
    
    func addNewFriend(_ email: String)
    
    func loadImage(url: String, completion: @escaping (UIImage) -> Void)
}

final class AccountPresenter: AccountPresenterProtocol {
    
    // MARK: - Properties
    
    private weak var coordinator: AccountChildCoordinator?
    
    private let authManager: AuthManagerDescription = AuthManager.shared
    private let accountManager: AccountManagerDescription = AccountManager.shared
    
    private let accountView: AccountViewProtocol?
    
    private var isNotificationTurnedOn = false
    
    private var user = User()
    private var friends = [User]()
    
    // MARK: - Init
    
    init(accountView: AccountViewProtocol) {
        self.accountView = accountView
    }
    
    func setCoordinator(with coordinator: AccountChildCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Handlers
    
    func showExitAlertController(completion: @escaping () -> ()) {
        coordinator?.presentExitController(completion: completion)
    }
    
    // MARK: - Buttons tapped
    
    func exitButtonTapped() {
        let err = authManager.signOut()
        guard let error = err else {
            coordinator?.showLogin()
            return
        }
        showErrorAlertController(with: error.toString())
    }
    
    func deleteTapped(for friend: User) {
        accountManager.deleteFriend(friend)
        guard let friendInd = friends.firstIndex(of: friend) else { return }
        friends.remove(at: friendInd)
        accountView?.reloadView()
    }
    
    func imageIsChanged(with image: UIImage?) {
        accountManager.changeUserAvatar(with: image) { [weak self] (err) in
            guard let self = self else { return }
            if let error = err {
                self.showErrorAlertController(with: error.toString())
            }
        }
    }
    
    func userNameDidChange(with name: String) {
        // изменение названия комнаты
        if user.name != name {
            accountManager.changeName(for: user, newName: name) { [weak self] (err) in
                guard let err = err else { return }
                self?.showErrorAlertController(with: err.toString())
            }
        }
    }
    
    // MARK: - Loading Data
    
    func didLoadView() {
        accountManager.observeCurrentUser { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.user = user
                self.accountView?.setUp(with: user)
                self.loadData()
            case .failure(let error):
                self.showErrorAlertController(with: error.toString())
            }
        }
    }
    
    private func loadData() {
        accountManager.getUser(userId: nil) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.user = user
                self.getFriends(for: user)
            case .failure(let error):
                self.showErrorAlertController(with: error.toString())
            }
        }
    }
    
    func getFriends(for user: User) {
        friends.removeAll()
        for friendId in user.friends {
            accountManager.getUser(userId: friendId) { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    self.friends.append(user)
                    self.accountView?.reloadView()
                case .failure(let error):
                    self.showErrorAlertController(with: error.toString())
                }
            }
        }
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
    
    func getAllFriends() -> [User] {
        friends
    }
    
    func getFriend(by index: Int) -> User? {
        if index < friends.count {
            return friends[index]
        }
        return nil
    }
    
    func addNewFriend(_ email: String) {
        accountManager.getUser(email: email) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.accountManager.addFriend(friend: user)
                if !self.friends.contains(user) {
                    self.friends.append(user)
                }
                self.accountView?.reloadView()
                self.accountView?.cleanErrorLabel()
                self.accountView?.cleanFriendTextField()
                self.accountView?.dismissAddNewFriendView()
            case .failure(_):
                self.accountView?.showError(with: "Пользователь не найден")
            }
        }
    }
    
}

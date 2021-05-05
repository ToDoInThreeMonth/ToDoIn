import Foundation

protocol FriendSearchViewPresenter {
    init(friendSearchView: FriendSearchView)
    func setCoordinator(with coordinator: AccountChildCoordinator)
    
    func getChoosedUser() -> User?
    
    func searchFieldDidChange(with text: String)
    func addButtonTapped()
}

class FriendSearchPresenter: FriendSearchViewPresenter {
    
    // MARK: - Properties
    
    weak var coordinator: AccountChildCoordinator?
    
    private let accountManager: AccountManagerDescription = AccountManager.shared
    
    private let friendSearchView: FriendSearchView?
    
    private var choosedUser: User?
    
    // MARK: - Init
    
    required init(friendSearchView: FriendSearchView) {
        self.friendSearchView = friendSearchView
    }
    
    // MARK: - Configures
    
    func setCoordinator(with coordinator: AccountChildCoordinator) {
        self.coordinator = coordinator
    }
    
    //MARK: - Handlers
    
    func getChoosedUser() -> User? {
        choosedUser
    }
    
    func searchFieldDidChange(with text: String) {
        accountManager.getUser(by: text) { [weak self] (result) in
            switch result {
            case .success(let user):
                self?.choosedUser = user
                self?.friendSearchView?.setUpResultLabel(user: user)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func addButtonTapped() {
        guard let friend = choosedUser else {
            return
        }
        accountManager.addFriend(friend: friend)
    }

}


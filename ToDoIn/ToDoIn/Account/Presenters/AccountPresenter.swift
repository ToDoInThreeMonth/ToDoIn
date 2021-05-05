import Foundation

protocol AccountViewPresenter {
    init(accountView: AccountView)
    func setCoordinator(with coordinator: AccountChildCoordinator)
    
    func addFriendsButtonTapped()
}

class AccountPresenter: AccountViewPresenter {
    
    // MARK: - Properties
    
    weak var coordinator: AccountChildCoordinator?
    
    private let accountView: AccountView?
    
    // MARK: - Init
    
    required init(accountView: AccountView) {
        self.accountView = accountView
    }
    
    func setCoordinator(with coordinator: AccountChildCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Configures
    
    func addFriendsButtonTapped() {
        coordinator?.showFriendSearch()
    }
}

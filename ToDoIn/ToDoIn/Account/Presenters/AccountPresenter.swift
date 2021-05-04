import Foundation

protocol AccountViewPresenter {
    
}

class AccountPresenter: AccountViewPresenter {
    
    // MARK: - Properties
    
    weak var coordinator: AccountChildCoordinator?
    
    private let accountView: AccountView?
    
    // MARK: - Init
    
    required init(accountView: AccountView) {
        self.accountView = accountView
    }
    
    // MARK: - Configures
    
}

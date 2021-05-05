import Foundation

class MainPresenter: MainViewPresenter {
    
    // MARK: - Properties
    
    weak var coordinator: MainChildCoordinator?

    private let mainView: MainView?
    
    // MARK: - Init
    
    required init(mainView: MainView) {
        self.mainView = mainView
    }
    
    // MARK: - Handlers
    
    func setCoordinator(with coordinator: MainChildCoordinator) {
        self.coordinator = coordinator
    }
    
    func buttonSignPressed(isSignIn: Bool) {
        coordinator?.showSignController(isSignIn: isSignIn)
    }
}

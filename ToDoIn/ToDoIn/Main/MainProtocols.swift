import Foundation

// MainController

protocol MainView: class {
    func setPresenter(presenter: MainViewPresenter, coordinator: MainChildCoordinator)
}


protocol MainViewPresenter {
    func setCoordinator(with coordinator: MainChildCoordinator)
    
    func buttonSignPressed(isSignIn: Bool)
}

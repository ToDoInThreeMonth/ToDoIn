import Foundation

// MainController

protocol MainView: class {
    func setPresenter(presenter: MainViewPresenter, coordinator: MainChildCoordinator)
}


protocol MainViewPresenter {
    func setCoordinator(with coordinator: MainChildCoordinator)
    
    func buttonSignPressed(isSignIn: Bool)
}


// AuthController

protocol AuthView: class {
    func getEmail() -> String
    func getName() -> String
    func getPassword1() -> String
    func getPassword2() -> String
    
    func showError(_ message:String)
}

protocol AuthViewPresenter {
    init(authView: AuthView)
    
    func buttonSignTapped(isSignIn: Bool) -> Bool
}

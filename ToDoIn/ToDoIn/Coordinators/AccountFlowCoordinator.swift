import UIKit

protocol AccountChildCoordinator: ChildCoordinator {
    func presentErrorController(with message: String)
    func presentExitController()
}

class AccountFlowCoordinator: AccountChildCoordinator {
    var navigationController: UINavigationController
    
    private let imageName: String
    private let title: String
    
    init(navigationController: UINavigationController, imageName: String, title: String) {
        self.navigationController = navigationController
        self.imageName = imageName
        self.title = title
    }
    
    func start() {
        let presenter = AccountPresenter(coordinator: self)
        let viewController = AccountViewController(presenter: presenter)
        
        let tabBarImage = UIImage(named: imageName)
        
        // Пример настройки tabBar'a
        viewController.tabBarItem = UITabBarItem(title: title, image: tabBarImage?.withRenderingMode(.alwaysOriginal), selectedImage: tabBarImage?.withRenderingMode(.alwaysOriginal))
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func presentExitController() {
        let alertTitle = "Выход из аккаунта"
        let alertMessage = "Вы действительно хотите выйти ?"
        let alertVC = AlertControllerCreator.getController(title: alertTitle, message: alertMessage, style: .alert, type: .logOut)
     
        navigationController.present(alertVC, animated: true)
    }
    
    func presentErrorController(with message: String) {
        let alertTitle = "Неожиданный сбой"
        let alertVC = AlertControllerCreator.getController(title: alertTitle, message: message, style: .alert, type: .error)
        
        navigationController.present(alertVC, animated: true)
    }
}
    
    

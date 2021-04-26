import UIKit

protocol MainChildCoordinator: ChildCoordinator {
    func showAddSection()
    func showTaskInfo()
}

class MainFlowCoordinator: MainChildCoordinator {
    var navigationController: UINavigationController
    
    private let title: String
    
    init(navigationController: UINavigationController, title: String) {
        self.navigationController = navigationController
        self.title = title
    }
    
    func start() {
        let viewController = MainController()
        viewController.coordinator = self
        
        // Пример настройки tabBar'a
        viewController.tabBarItem = UITabBarItem(title: title, image: nil, selectedImage: nil)
        
        // Пример настройки viewController
        viewController.view.backgroundColor = .white
        viewController.title = title
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
    
    func showAddSection() {
        navigationController.viewControllers.last?.present(AddSectionController(), animated: true, completion: nil)
    }
    
    func showTaskInfo() {}
}

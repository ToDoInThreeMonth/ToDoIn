import UIKit

protocol MainChildCoordinator: ChildCoordinator {
    func showAddSection()
    func showAddTask()
}

class MainFlowCoordinator: MainChildCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = ViewController()
        viewController.coordinator = self
        // Пример настройки tabBar'a
        viewController.tabBarItem = UITabBarItem(title: "Main", image: UIImage(systemName: "checkmark"), selectedImage: UIImage(systemName: "checkmark"))
        // Пример настройки viewController
        viewController.title = "MainViewController"
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
//  Пока заглушки. Эти методы для вызова экранов добавления секции и задачи
    func showAddSection() {}
    func showAddTask() {}
}

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
        viewController.tabBarItem = UITabBarItem(title: "Main", image: UIImage(named: "main")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "main")?.withRenderingMode(.alwaysOriginal))
        // Пример настройки viewController
        viewController.view.backgroundColor = .white
        viewController.title = "Главная"
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
//  Пока заглушки. Эти методы для вызова экранов добавления секции и задачи
    func showAddSection() {}
    func showAddTask() {}
}

class AccountFlowCoordinator: MainChildCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = ViewController()
        viewController.coordinator = self
        // Пример настройки tabBar'a
        viewController.tabBarItem = UITabBarItem(title: "Account", image: nil, selectedImage: nil)
        // Пример настройки viewController
        viewController.view.backgroundColor = .white
        viewController.title = "Аккаунт"
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
//  Пока заглушки. Эти методы для вызова экранов добавления секции и задачи
    func showAddSection() {}
    func showAddTask() {}
}

class SettingsFlowCoordinator: MainChildCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = ViewController()
        viewController.coordinator = self
        // Пример настройки tabBar'a
        viewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settings")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "settings")?.withRenderingMode(.alwaysOriginal))
        // Пример настройки viewController
        viewController.view.backgroundColor = .white
        viewController.title = "Настройки"
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
//  Пока заглушки. Эти методы для вызова экранов добавления секции и задачи
    func showAddSection() {}
    func showAddTask() {}
}

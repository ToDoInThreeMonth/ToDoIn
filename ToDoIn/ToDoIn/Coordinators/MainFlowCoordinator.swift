import UIKit

protocol MainChildCoordinator: ChildCoordinator {
    func showAddSection()
    func showAddTask()
}

class MainFlowCoordinator: MainChildCoordinator {
    var navigationController: UINavigationController
    
    private let imageName: String
    private let title: String
    
    init(navigationController: UINavigationController, imageName: String, title: String) {
        self.navigationController = navigationController
        self.imageName = imageName
        self.title = title
    }
    
    func start() {
        let viewController = ViewController()
        viewController.coordinator = self
        var tabBarImage: UIImage?
        if imageName == "" {
            tabBarImage = nil
        } else {
            tabBarImage = UIImage(named: imageName)
        }
        // Пример настройки tabBar'a
        viewController.tabBarItem = UITabBarItem(title: title, image: tabBarImage?.withRenderingMode(.alwaysOriginal), selectedImage: tabBarImage?.withRenderingMode(.alwaysOriginal))
        // Пример настройки viewController
        viewController.view.backgroundColor = .white
        viewController.title = title
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
//  Пока заглушки. Эти методы для вызова экранов добавления секции и задачи
    func showAddSection() {}
    func showAddTask() {}
}

//class AccountFlowCoordinator: MainChildCoordinator {
//    var navigationController: UINavigationController
//
//    init(navigationController: UINavigationController) {
//        self.navigationController = navigationController
//    }
//
//    func start() {
//        let viewController = ViewController()
//        viewController.coordinator = self
//        // Пример настройки tabBar'a
//        viewController.tabBarItem = UITabBarItem(title: "Account", image: nil, selectedImage: nil)
//        // Пример настройки viewController
//        viewController.view.backgroundColor = .white
//        viewController.title = "Аккаунт"
//
//        navigationController.pushViewController(viewController, animated: false)
//    }
//
////  Пока заглушки. Эти методы для вызова экранов добавления секции и задачи
//    func showAddSection() {}
//    func showAddTask() {}
//}
//
//class SettingsFlowCoordinator: MainChildCoordinator {
//    var navigationController: UINavigationController
//
//    init(navigationController: UINavigationController) {
//        self.navigationController = navigationController
//    }
//
//    func start() {
//        let viewController = ViewController()
//        viewController.coordinator = self
//        // Пример настройки tabBar'a
//        viewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settings")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "settings")?.withRenderingMode(.alwaysOriginal))
//        // Пример настройки viewController
//        viewController.view.backgroundColor = .white
//        viewController.title = "Настройки"
//
//        navigationController.pushViewController(viewController, animated: false)
//    }
//
////  Пока заглушки. Эти методы для вызова экранов добавления секции и задачи
//    func showAddSection() {}
//    func showAddTask() {}
//}
